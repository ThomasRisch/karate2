# encoding: utf-8
class ListsController < ApplicationController

  def index
    @courses = Course.where('course_end IS NOT NULL AND date(strftime("%Y", course_end)||"-01-01") >= date((strftime("%Y", "now")-1)||"-01-01")')  # all ongoing plus onetime within a year
    @trainings = Course.where('course_start IS NULL')
    @exams = Grading.where(:grading_date => 12.months.ago..Time.now).uniq.pluck(:grading_date)


    
    respond_to do |format|
      format.html # index.html.erb
    end


  end

  def courses

    if params[:course]!='' then
      @course_id = params[:course]
    end
    if params[:training] != '' then
      @course_id = params[:training]
    end

    if params[:list]

      output = MemberlistReport.new.to_pdf(@course_id)
      send_data output, :filename => "Teilnehmerliste.pdf", :type => "application/pdf"

    elsif params[:email]

      output = EmailReport.new.to_pdf(@course_id)
      send_data output, :filename => "Email.pdf", :type => "application/pdf"

    elsif params[:csv]



# for J+S Database
#
#      # Header
#      output = "NDBJS_PERS_NR;GESCHLECHT;NAME;VORNAME;GEB_DATUM;STRASSE;PLZ;ORT;LAND;NATIONALITAET;ERSTSPRACHE;KLASSE/GRUPPE\n"
#
#      # Data
#      people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + @course_id.to_s)   
#
#      people.each do |person|
#        row = ''
#        row += ';'           # NDBJS_PERS_NR
#        row += 'm;'          # GESCHLECHT M oder F
#        row += person.lastname.to_s + ';'    # Umlaute sind problematisch.
#        row += person.firstname.to_s + ';' 
#        row += person.birthday.to_s + ';'
#        row += ';'           # STRASSE
#        row += person.zipcity.split(" ").first + ';'
#        case person.zipcity.split(" ").last
#        when "Birmensdorf"
#          row += "Birmensdorf ZH"
#        when "Arni"
#          row += "Arni AG"
#        else
#          row += person.zipcity.split(" ").last + ';'
#        end
#        row += ';'           # LAND
#        row += 'CH;'         # NATIONALITAET
#        row += 'D;'          # ERSTSPRACHE
#        row += ''            # KLASSE/GRUPPE
#        output = output + row + "\n"
#      end


      # Header
      output = "NAME;VORNAME;BILL_NAME;BILL_VORNAME;STRASSE;ORT;GRUPPE\n"

      # Data
      people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + @course_id.to_s)
      course = Course.find(@course_id)

      people.each do |person|
        row = ''
        row += person.lastname.to_s + ';'    # Umlaute sind problematisch.
        row += person.firstname.to_s + ';'
        row += person.bill_lastname.to_s + ';'
        row += person.bill_firstname.to_s + ';'
        row += person.street.to_s + ';'
        row += person.zipcity.to_s + ';'
        row += course.course_name.to_s.strip            # KLASSE/GRUPPE
        output = output + row + "\n"
      end

      send_data output, :filename => "course.csv", :type => "application/txt"


    end

  end

  def exams

    if params[:exam] != '' then
      @exam_date = params[:exam]
    else
      @exam_date=''
    end

    gradings = Grading.where(:grading_date => Date.parse(@exam_date))
    
    output = "Prüfung vom " + Date.parse(@exam_date).to_s + "\n" + "\n"

    gradings.each do |x|
      person = Person.find(x.person_id) 
      grade = Grade.find(x.grade_id)
      row = ''
      row += person.firstname + " " + person.lastname
      row += " => "
      row += grade.name + ", " + grade.color
      output = output + row + "\n"
    end

    send_data output, :filename => "exam.txt", :type => "application/txt"

  end

end
