# encoding: utf-8

class MemberlistReport < Prawn::Document
  def to_pdf(course_id)

    title = "Kursteilnehmer " + Course.find(course_id).course_name
    people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + course_id.to_s)
#                         :conditions => "people.leave_date IS NULL"

    font_size 24
    text title
    font_size 10

    table_content = [["<b>Name</b>", "<b>Adresse</b>", "<b>Telefon</b>", "<b>E-Mail</b>"]]
    people.each do |person|    
      row = []
      row << person.name.to_s + "\n <em>" + person.birthday.to_s + "</em>"
      row << person.street.to_s + "\n" + person.zipcity.to_s
      row << "P: " + person.phone.to_s + "\n" + "M: " + person.mobile.to_s
      row << person.email.to_s + "\n" + person.bill_email.to_s
      table_content << row
    end

    table(table_content, :header => true, :row_colors => ["F0F0F0", "FFFFFF"], :cell_style => { :inline_format => true })

    render
  end
end
