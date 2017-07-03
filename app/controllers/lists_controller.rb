# encoding: utf-8
class ListsController < ApplicationController

  def index
    @courses = Course.where('course_end IS NOT NULL AND date(strftime("%Y", course_end)||"-01-01") >= date((strftime("%Y", "now")-1)||"-01-01")')  # all ongoing plus onetime within a year
    @trainings = Course.where('course_start IS NULL')
	    @exams = Grading.where('grading_date > ?', 12.months.ago).uniq.pluck(:grading_date)

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

    elsif params[:nextEx]
      output = ""
      nextGrading = ""

      # Loop über alle Personen des Kurses
      people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + @course_id.to_s)

      people.each do |person|
  
        
        # finde Prüfungen in Zukunft
        gradings = Grading.find(:all, :conditions => "gradings.person_id = " + person.id.to_s + " AND gradings.grading_date > '" + DateTime.now.to_s + "'")

        # Loop über alle Prüfungen
        color = ""
        gradings.each do |grading|
          # finde Farbe
          grade = Grade.find(grading.grade_id)
          color += grade.color + " / "
        end 

        if gradings.size > 0
          output += person.firstname + " " + person.lastname + "\t" + color.chomp(" / ") + "\n"
        end

      end

      output = "Kommende Prüfung: " + nextGrading.chomp(", ") + "\n\n" + output

      send_data output, :filename => "Prüfungsliste.txt", :type => "application/txt"

    elsif params[:csv]



# for J+S Database

      # Header
      output = "NDBJS_PERS_NR;GESCHLECHT;NAME;VORNAME;GEB_DATUM;STRASSE;PLZ;ORT;LAND;NATIONALITAET;ERSTSPRACHE;KLASSE/GRUPPE\n"

      # Data
      people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + @course_id.to_s)   

      people.each do |person|
        row = ''
        row += ';'           # NDBJS_PERS_NR
        row += 'm;'          # GESCHLECHT M oder F
        row += person.lastname.to_s + ';'    # Umlaute sind problematisch.
        row += person.firstname.to_s + ';' 
        row += person.birthday.strftime("%d.%m.%Y") + ';'
        row += ';'           # STRASSE
        row += person.zipcity.split(" ").first + ';'
        case person.zipcity.split(" ").last
        when "Birmensdorf"
          row += "Birmensdorf ZH"
        when "Arni"
          row += "Arni AG"
        else
          row += person.zipcity.split(" ").last
        end
        row += ';;'           # LAND
        row += 'CH;'         # NATIONALITAET
        row += 'D;'          # ERSTSPRACHE
        row += ''            # KLASSE/GRUPPE
        output = output + row + "\n"
      end

      send_data output.encode("windows-1252", "UTF-8"), :filename => "course.csv", :type => "application/txt"
    end

  end

  def email

    # getting all selected course id's in an array
    courses = Array.new

    if !params[:course].nil? then
      courses += params[:course]
    end
    if !params[:training].nil? then
      courses += params[:training]
    end
    if courses.size == 0 then
      output = "Kein Kurs angewählt."
    end

    # getting all people with selected course id's (can't get smarter way than direct SQL)
    people = Person.find_by_sql(["select firstname, lastname, email, bill_email, course_id from people inner join courses_people on people.id = courses_people.person_id where people.leave_date is null and course_id in (?)", courses])

    all_mails = ""
    missed_mails = ""
    people.each do |person|
      e = ""
      e += person.email.to_s

      # bill email if no personal email
      if e == "" then
        e += person.bill_email.to_s
      end

      # exception if no mail at all
      if e == "" then
        missed_mails += person.firstname + " " + person.lastname + ", "
      else
        all_mails += e + ", "
      end
      
    end


    output = "Emails:\n" + all_mails.chomp(", ") + "\n"+ "\n"
    output += "Fehlt:\n" + missed_mails.chomp(", ") + "\n"


    send_data output.encode("windows-1252", "UTF-8"), :filename => "email.txt", :type => "application/txt"


  end

  def exams

    if !params[:exam].blank? then
      @exam_date = params[:exam].map(&:to_date)
      output = "Prüfung vom " + @exam_date.to_sentence + "\n" + "\n"
    else
      @exam_date=''
      output = "Keine Prüfung angewählt."
    end

    if params[:participants] 
      gradings = Grading.where(grading_date: @exam_date) 
    
      gradings.each do |x|
        person = Person.find(x.person_id) 
        row = ''
        row += x.grading_date.to_s + ", "
        row += person.lastname + ", " + person.firstname

        row += ", "
        grade = Grade.find(x.grade_id)
        row += grade.name + ", " + grade.color
        output += row + "\n"
      end
      send_data output, :filename => "exam.txt", :type => "application/txt"


    elsif params[:urkunde]
      gradings = Grading.where(grading_date: @exam_date)

      ur = Array.new  
      i = 0
      gradings.each do |x|
        person = Person.find(x.person_id)
        row = ''
        row += x.grading_date.to_s + ", "
        row += person.lastname + ", " + person.firstname

        row += ", "
        grade = Grade.find(x.grade_id)
        row += grade.name + ", " + grade.color
        ur[i] = {:lastname => person.lastname, :firstname => person.firstname, :date => x.grading_date, :kyu => grade.name, :color => grade.color}
        i += 1
      end
      output = UrkundeReport.new.to_pdf(ur)
      send_data output, :filename => "exam.pdf", :type => "application/pdf"

    end

  end

end
