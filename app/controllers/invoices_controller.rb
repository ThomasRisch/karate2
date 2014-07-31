# encoding: utf-8
class InvoicesController < ApplicationController

  # For monetize, nextBillNr
  include BillsHelper

  def index

    # Determine defaults for preparing bills
    @start_bill_prefix, @start_bill_nr = nextBillNr
    @bill_date = Time.now.day.to_s + "." + Time.now.month.to_s + "." + Time.now.year.to_s
    @courses = Course.where('course_end IS NULL OR date(strftime("%Y", course_end)||"-01-01") >= date((strftime("%Y", "now")-1)||"-01-01")')

    # Determine defaults for printing
    bills = Bill.find :all, 
                      :order=> "prefix ASC, nr ASC",
                      :conditions => ["paied_date IS NULL"]

    @from_bill_nr = "%05d" %(bills.first.nr.to_i).to_s if !bills.blank?
    @to_bill_nr = "%05d" %(bills.last.nr.to_i).to_s if !bills.blank?

  end

  def prepare

    bill_prefix = params[:bill_prefix]
    bill_nr = params[:bill_nr]
    bill_date = params[:bill_date]
    bill_course = params[:course]

    bill_array = generate_bills(bill_prefix.to_i, bill_nr.to_i, bill_date, bill_course)


    # preview button pressed
    if params[:preview]
      output = InvoicesReport.new.to_pdf(bill_array, bill_course)
      send_data output, :filename => "Rechnungen.pdf", :type => "application/pdf"

    # generate button pressed
    else
      bill_array.each do |bill|
        bill.save!   #raises exception if validation fails
      end
      redirect_to bills_path
    end   
  end

  def print

    from = params[:from_bill_nr]
    to = params[:to_bill_nr]

    bill_array = Bill.find(:all, :conditions => ["nr >= ? AND nr <= ? AND prefix = ?", from, to, "00000"])

    output = BillReport.new.to_pdf(bill_array) 
    send_data output, :filename => "Alle Rechnungen.pdf", :type => "application/pdf"
  end

  # ----------------------------------------------------------------------------------
  # Additional methods

  def generate_bills(bill_prefix_int, bill_nr_int, bill_date, bill_course)
 
    bill_array = Array.new
    
    # Loop over persons
#    person = Person.find :all, :order=> "lastname ASC, firstname ASC", 
#                         :conditions => "people.leave_date IS NULL"
    person = Person.includes(:courses).find :all, :order=> "lastname ASC, firstname ASC",
                                            :conditions => "people.leave_date IS NULL AND courses.id = " + bill_course.to_s

    i=0
    current_bill_nr = bill_nr_int

    person.each do |p|
      bill_array[i] = Bill.new

      # bill prefix / number
      bill_array[i].prefix = "%05d" % bill_prefix_int.to_s
      bill_array[i].nr = "%05d" % current_bill_nr.to_s
     
      bill_array[i].firstname = p.firstname
      bill_array[i].lastname = p.lastname
 
      # if bill_ is empty, normal name is taken
      p.bill_lastname.blank? ? bill_array[i].bill_lastname = p.lastname : bill_array[i].bill_lastname = p.bill_lastname
      p.bill_firstname.blank? ? bill_array[i].bill_firstname = p.firstname : bill_array[i].bill_firstname = p.bill_firstname
      p.bill_street.blank? ? bill_array[i].bill_street = p.street : bill_array[i].bill_street = p.bill_street
      p.bill_zipcity.blank? ? bill_array[i].bill_zipcity = p.zipcity : bill_array[i].bill_zipcity = p.bill_zipcity

      bill_array[i].bill_type = 'Rechnung'
      bill_array[i].salutation = p.salutation
      bill_array[i].person_id = p.id
      
      bill_array[i].issue_date = bill_date

      course = Course.find(bill_course)
      if course.course_start.blank? then   # it is an ongoing course


        # text line 1: amount
        if p.is_yearly then # yearly bill
          if Time.now.month > 3 and Time.now.month < 11 # yearly bill issued for October to April
            bill_array[i].text1 = "Jahresbeitrag 1. Oktober " + Time.now.year.to_s + " - 30. September " + (Time.now.year+1).to_s
            if not p.amount.blank?
              bill_array[i].amount1 = monetize(p.amount)
            else
              bill_array[i].text1 = "Error: Betrag ist leer!"
              bill_array[i].amount1 = "0.00"
            end
          else
            #leave everything empty; yearly bills not charged between April and October
          end
        else # semester bill
          next_semester = case Time.now.month
            when 1..3 then "1. April - 31. September " + Time.now.year.to_s
            when 4..9 then "1. Oktober " + Time.now.year.to_s + " - 31. März " + (Time.now.year+1).to_s
            when 10..12 then "1. April - 31. September " + (Time.now.year+1).to_s
            else "Error in invoices_controller"
          end
          bill_array[i].text1 = "Beitrag Halbjahr " + next_semester
          if not p.amount.blank?
            bill_array[i].amount1 = monetize(p.amount)
          else
            bill_array[i].text1 = "Error: Betrag ist leer!"
            bill_array[i].amount1 = "0.00"
          end
        end
     
      else     # it is a one time course
        bill_array[i].text1 = course.course_desc
        bill_array[i].amount1 = monetize(course.course_amount)
      end
 
      # text line 2: discount, only when there is an amount
      if (not p.discount.blank?) and (p.discount > 0) and (not bill_array[i].amount1.blank?)
        bill_array[i].text2 = "./. " + p.discount.to_i.to_s + "% Rabatt"
        bill_array[i].amount2 = "-" + monetize(bill_array[i].amount1.to_f/100*p.discount)
      end

      # text line 3: license, only for these that have a full colour belt
      if (Time.now.month > 3 and Time.now.month < 10) and (p.gradings.count > 1)
        bill_array[i].text3 = "Lizenzmarke " + (Time.now.year.to_i + 1).to_s + " Swiss Karate Federation"
        bill_array[i].amount3 = "60.00"
      end

      
      # calculate bill total
      total = bill_array[i].amount1.to_f + bill_array[i].amount2.to_f + bill_array[i].amount3.to_f
      bill_array[i].total = monetize(total)

      if total > 0 then
        i += 1
        current_bill_nr += 1
      else
        # remove all bills where total amount is zero
        bill_array.delete_at(i)
      end
    end
   
    return bill_array
  end

end
