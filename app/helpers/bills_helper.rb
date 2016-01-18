# encoding: utf-8

module BillsHelper
 
  #Helpers for update, create
  def nr_form_column(record, options)
    # default: next number 
    if @record.nr.blank?
      bill = Bill.find(:first, :order=> "created_at DESC, nr DESC")
      if bill
        @record.nr = "%05d" %((bill.nr.to_i) + 1).to_s
      else
        @record.nr = "000000"
      end
    end
    text_field :record, :nr, options
  end
  def prefix_form_column(record, options)
    # default: next number 
    if @record.prefix.blank?
      bill = Bill.find(:first, :order=> "created_at DESC")
      if bill
        @record.prefix = bill.prefix
      else
        @record.prefix = "000000"
      end
    end
    text_field :record, :prefix, options
  end
  
  def lastname_form_column(record, options)
    # fills in defaults for new bills (careful, should not trigger with edit action)
    # works only for bills controller, as in people_controller there is no person_id
    # strange enough that people_controller calls this method...
    if controller_name == 'bills' and not @record.person_id.blank? and action_name == 'new' then
      # if bill is created within a person,
      # set all default values
      person = Person.find_by_id @record.person_id
      @record.lastname = person.lastname
      @record.firstname = person.firstname
      @record.salutation = person.salutation
      @record.bill_streetprefix = person.bill_streetprefix
      person.bill_lastname.blank? ? @record.bill_lastname = person.lastname : @record.bill_lastname = person.bill_lastname
      person.bill_firstname.blank? ? @record.bill_firstname = person.firstname : @record.bill_firstname = person.bill_firstname
      person.bill_street.blank? ? @record.bill_street = person.street : @record.bill_street = person.bill_street
      person.bill_zipcity.blank? ? @record.bill_zipcity = person.zipcity : @record.bill_zipcity = person.bill_zipcity
      @record.bill_type = 'Rechnung'
      @record.company = 'Keiko Kan'
      @record.freetext = 'Herzlichen Dank für das Vertrauen.'
    end
    text_field :record, :lastname, options
  end

  def salutation_form_column(record, options)
    select :record, :salutation, ["", "Herr", "Frau", "Familie"]
  end
  def bill_type_form_column(record, options)
    select :record, :bill_type, ["Rechnung", "Erste Mahnung", "Zweite Mahnung"]
  end
  def company_form_column(record, options)
    select :record, :company, ["", "Keiko Kan", "Hühner-Rei", "Olivia KVV"]
  end

  def amount1_form_column(record, options)
    text_field :record, :amount1, options
  end
  def amount2_form_column(record, options)
    text_field :record, :amount2, options
  end
  def amount3_form_column(record, options)
    text_field :record, :amount3, options
  end
  def amount4_form_column(record, options)
    text_field :record, :amount4, options
  end
  def total_form_column(record, options)
    text_field :record, :total, options
  end
  def paied_amount_form_column(record, options)
    text_field :record, :paied_amount, options
  end


#  def company_search_column(record, input_name)
#    select :record, :company,  options_for_select(['open', 'closed'])
#  end

  # Helper to get number into a currency format string
  # Credits:
  # http://www.brianmcquay.com/monitary-precision-of-a-ruby-float/86
  def monetize(number)
    splitnum = number.to_s.split(".")[0]
    scale = number.to_s.split(".")[1][0..1]
    while scale.length < 2
      scale = scale + '0'
    end
    "#{splitnum}.#{scale}"
    
  end

  def nextBillNr
    currentBill = Bill.find(:first, :order=> "created_at DESC, nr DESC")
    if currentBill.blank?
      prefix = "00000"
      nr = "00000"
    else
      prefix = currentBill.prefix
      nr = "%05d" %((currentBill.nr.to_i) + 1).to_s
    end
    return prefix, nr
  end

  def currentBillNr
    currentBill = Bill.find(:first, :order=> "created_at DESC, nr DESC")
    if currentBill.blank?
      prefix = "00000"
      nr = "00000"
    else
      prefix = currentBill.prefix
      nr = "%05d" %currentBill.nr
    end
    return prefix, nr
  end


end
