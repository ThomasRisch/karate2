class ListsController < ApplicationController
  def index
    @people= Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end

  end

  def courses

    @course_id = params[:course]

    if params[:list]

      output = MemberlistReport.new.to_pdf(@course_id)
      send_data output, :filename => "Teilnehmerliste.pdf", :type => "application/pdf"

    elsif params[:email]

      output = EmailReport.new.to_pdf(@course_id)
      send_data output, :filename => "Email.pdf", :type => "application/pdf"

    elsif params[:csv]

      # Header
      output = "NDBJS_PERS_NR;GESCHLECHT;NAME;VORNAME;GEB_DATUM;STRASSE;PLZ;ORT;LAND;NATIONALITAET;ERSTSPRACHE;KLASSE/GRUPPE\n"

      # Data
      people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + @course_id.to_s)   

      people.each do |person|
        row = ''
        row += ';'           # NDBJS_PERS_NR
        row += 'm;'          # GESCHLECHT
        row += person.lastname.to_s + ';'
        row += person.firstname.to_s + ';' 
        row += person.birthday.to_s + ';'
        row += ';'           # STRASSE
        row += ';'           # PLZ
        row += ';'           # ORT
        row += ';'           # LAND
        row += 'CH;'         # NATIONALITAET
        row += 'D;'          # ERSTSPRACHE
        row += ''            # KLASSE/GRUPPE
        output = output + row + "\n"
      end

      send_data output, :filename => "course.csv", :type => "application/txt"

    end
  end

end
