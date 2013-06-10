# encoding: utf-8

class EmailReport < Prawn::Document
  def to_pdf(course_id)

    title = "Email-Adressen " + Course.find(course_id).course_name
    people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + course_id.to_s)
#                         :conditions => "people.leave_date IS NULL"

    font_size 24
    text title
    font_size 10

    all_mails = ""
    missing_mails = ""
    two_mails = ""

    people.each do |person|    

      # Keine Mailadresse zur Rechnung
      if person.bill_email.nil?

        if person.email.nil?
          missing_mails = missing_mails + person.name.to_s + "\n" 
        else
          all_mails = all_mails + person.email.to_s + ", "
        end
      
      # Rechnungsadresse enthält Mail, dies ist die "erwachsene" Mailadresse.
      else
        all_mails = all_mails + person.bill_email.to_s + ", "
        if !person.email.nil?
          two_mails = two_mails + person.name.to_s + "\n"
        end
      end 

    end

    text "\n" 
    text "<b>Mail-Verteiler</b>"  + "\n", :inline_format => true
    text all_mails  + "\n\n"

    #if !missing_mails==""
      text "<b>Fehlende Mail Adressen</b>"  + "\n", :inline_format => true
      text missing_mails + "\n\n"
    #end

    #if !two_mails==""
      text "<b>Zwei Mail Adressen</b>, die Rechnungs-Mailadresse hat Priorität."  + "\n", :inline_format => true
      text two_mails
    #end

    render
  end
end
