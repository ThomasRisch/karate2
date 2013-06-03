# encoding: utf-8
class BillsController < ApplicationController

  # For monetize
  include BillsHelper


  active_scaffold :bill do |conf|

    conf.columns = [:id, :fullnr, :prefix, :nr, 
                    :name, :firstname, :lastname, :salutation,
                    :bill_name, :bill_firstname, :bill_lastname,
                    :bill_street, :bill_zipcity,
                    :text1, :amount1, :line1,
                    :text2, :amount2, :line2,
                    :text3, :amount3, :line3,
                    :text4, :amount4, :line4, 
                    :total, :issue_date, :line_total,
                    :paied_amount, :paied_date, :line_paied,
                    :freetext, :bill_type, :comment]
    columns[:fullnr].label = 'EZ Nummer'
    columns[:prefix].label = 'Präfix'
    columns[:nr].label = 'Rechnungsnummer'
    columns[:name].label = 'Name, Vorname'
    columns[:lastname].label = 'Nachname'
    columns[:firstname].label = 'Vorname'
    columns[:salutation].label = 'Anrede'
    columns[:bill_street].label = 'Strasse'
    columns[:bill_zipcity].label = 'PLZ Ort'
    columns[:bill_name].label = 'Name, Vorname für Rechnung'    
    columns[:bill_lastname].label = 'Rechnung - Nachname'
    columns[:bill_firstname].label = 'Rechnung - Vorname'
    columns[:text1].label = 'Zeile 1'
    columns[:amount1].label = 'Betrag 1'
    columns[:line1].label = 'Betrag, Zeile 1'
    columns[:text2].label = 'Zeile 2'
    columns[:amount2].label = 'Betrag 2'
    columns[:line2].label = 'Betrag, Zeile 2'
    columns[:text3].label = 'Zeile 3'
    columns[:amount3].label = 'Betrag 3'
    columns[:line3].label = 'Betrag, Zeile 3'
    columns[:text4].label = 'Zeile 4'
    columns[:amount4].label = 'Betrag 4'
    columns[:line4].label = 'Betrag, Zeile 4'
    columns[:total].label = 'Totalbetrag'
    columns[:issue_date].label = 'Rechnungsdatum'
    columns[:line_total].label = 'Total, Datum'
    columns[:paied_date].label = 'Bezahlt am'
    columns[:paied_amount].label = 'Betrag bezahlt'
    columns[:line_paied].label = 'Bezahlt, Datum'
    columns[:freetext].label = 'Freitext'
    columns[:bill_type].label = 'Rechnungsart'
    columns[:comment].label = 'Kommentar'


    columns[:total].calculate = :sum


    list.columns = [:fullnr, :name, :issue_date, :total, :paied_date, :paied_amount, :bill_type]
    show.columns.exclude :id, :prefix, :nr,
                         :firstname, :lastname, :bill_firstname, :bill_lastname,
                         :text1, :amount1, :text2, :amount2,
                         :text3, :amount3, :text4, :amount4,
                         :total, :issue_date, :paied_date, :paied_amount
    create.columns.exclude :id
    update.columns.exclude :id

    # Seachr is ignored based on return level of the search_ignore function defined later down 
    conf.search.link.ignore_method = :search_ignore?

    list.label = 'Rechnungen'
    list.sorting = [{ :prefix => :asc}, {:nr => :asc}]
    list.per_page = 50

    columns[:name].sort_by :sql => 'lastname||firstname'
    columns[:fullnr].sort_by :sql => 'prefix||nr'
    
    create.link.label = 'Neue Rechnung'
    create.label = 'Neue Rechnung'

    action_links.add 'pay', :action => "pay",
      :label => "Quittieren", :type => :member
 
    action_links.add 'print', :action => "print", 
      :label => "Drucken", :type => :member, :page => true
  
    action_links.add 'remind', :action => "remind", 
      :label => "Mahnen", :type => :member
  
    update.link.label = 'Ändern'
    update.label = 'Ändern'
    
    show.link.label = 'Details'
    show.label = 'Details'

    delete.link.label = 'Löschen'

    search.link.label = 'Suchen'

  end

  # Create not available in main form, but in nested
  def create_ignore?
   super || !nested?
  end

  # Search only available in main form
  def search_ignore?
    nested?
  end

  # in main form, show only unpaied bills
  def conditions_for_collection
    if !nested? then
      ['paied_date is null']
    end
  end

  def all
  end

  def pay
    @record = Bill.find(params[:id])
    # suggests total to be paied
    @record.paied_amount = @record.total
    # suggests last seen paied_date
    temp_rec = Bill.find(:first, :order=> "paied_date DESC")
    @record.paied_date = temp_rec.paied_date
  end

  def pay_final
    temp_rec = params[:record]

    @record = Bill.find(params[:id])
    # @template gives access to helper methods!
    @record.paied_amount = monetize(temp_rec[:paied_amount].to_f)
    @record.comment = temp_rec[:comment]
    @record.paied_date = temp_rec[:paied_date]
    @record.save
    redirect_to :action => 'index'
  end



  def print
    records = Bill.find(:all, :conditions => ["id = ?", params[:id]])

    output = BillReport.new.to_pdf(records)
    send_data output, :filename => "Rechnung.pdf", :type => "application/pdf"

  end
  

  def remind
    old_bill = Bill.find_by_id params[:id]

    # Logic: reminder1 with new EZ
    #        reminder2 with new EZ, 25.- Mahngebühr
    #        not more than two automated reminders 
   
    # only remind rechnung and first reminder 
    if (old_bill.bill_type != "Rechnung") && (old_bill.bill_type != "Erste Mahnung") then
      redirect_to :action => 'index'
      return
    end

    # No remind if already paied
    if !old_bill.paied_date.blank?
      redirect_to :action => 'index'
      return
    end



    new_bill = old_bill.dup
      
    # calculate next bill number
    next_bill = Bill.find(:first, :order=> "created_at DESC")
    new_bill.nr = "%05d" %((next_bill.nr.to_i) + 1).to_s
    new_bill.prefix = next_bill.prefix


    if old_bill.bill_type == "Erste Mahnung" then
      new_bill.bill_type = "Zweite Mahnung"

      # add Mahngebühr
      if new_bill.amount2.blank?
        new_bill.amount2 = '25.00'
        new_bill.text2 = 'Bearbeitungsgebühr'
      elsif new_bill.amount3.blank?
        new_bill.amount3 = '25.00'
        new_bill.text3 = 'Bearbeitungsgebühr'
      else
        new_bill.amount4 = '25.00'
        new_bill.text4 = 'Bearbeitungsgebühr'
      end
      new_bill.total = monetize(new_bill.total.to_f + 25.0)

      new_bill.freetext = "Leider ist Ihre Zahlung bis heute nicht bei uns eingetroffen. Wir bitten Sie, "
      new_bill.freetext = new_bill.freetext + "uns den Betrag innerhalb zwei Wochen zu überweisen. Dies ist die "
      new_bill.freetext = new_bill.freetext + "zweite Mahnung. Wir stellen für die Umtriebe eine Bearbeitungsgebühr in Rechnung. "
      
    else  # old_bill.bill_type == "Rechnung"
      new_bill.bill_type = "Erste Mahnung"

      new_bill.freetext = "Leider ist Ihre Zahlung bis heute nicht bei uns eingetroffen. Wir bitten Sie, "
      new_bill.freetext = new_bill.freetext + "uns den Betrag innerhalb zwei Wochen zu überweisen."

    end
    
    new_bill.issue_date = Time.now.day.to_s + "." + Time.now.month.to_s + "." + Time.now.year.to_s
    new_bill.save
    
    # close old bill
    old_bill.paied_date = new_bill.issue_date
    old_bill.paied_amount = "0.00"
    old_bill.comment = "Gemahnt"
    old_bill.save
    redirect_to :action => 'index'
    
  end
 
end 
