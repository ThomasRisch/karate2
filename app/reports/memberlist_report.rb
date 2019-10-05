# encoding: utf-8

class MemberlistReport < Prawn::Document
  def to_pdf(course_id)

    title = "Kursteilnehmer " + Course.find(course_id).course_name
    people = Person.find(:all, :include => :courses, :order=> "lastname ASC, firstname ASC", :conditions => "people.leave_date IS NULL AND courses.id = " + course_id.to_s)
#                         :conditions => "people.leave_date IS NULL"

    font_size 24
    text title
    font_size 10

    table_content = [["<b>Name</b>", "<b>Telefon</b>", "<b>Grad</b>", "<b>Bemerkungen</b>"]]
    people.each do |person|    


      if person.birthday.blank? then
        birthday = "-"
      else
        birthday = I18n.l(person.birthday)
      end
      if person.entry_date.blank? then
        entry_date = "-"
      else
        entry_date = I18n.l(person.entry_date)
      end

      current_grading = Grading.find(:last, :conditions => "person_id = " + person.id.to_s)
      if not current_grading
        grading_desc = "Eintritt:"
        grading_date = entry_date
#        graded_since = ""
        trainings = ""
      else
        grade = Grade.find(current_grading.grade_id)
        grading_desc = grade.name + " - " + grade.color
        if current_grading.grading_date.blank? then
          grading_date = "-"
#          graded_since = ""
        else
          grading_date = I18n.l(current_grading.grading_date).to_s
#          graded_since = (DateTime.now - current_grading.grading_date).to_i.to_s + " Tagen"
        end
#        if current_grading.trainings.blank? then
#          trainings = ""
#        else
#          trainings = current_grading.trainings.to_s + " Trainings"
#        end
	if current_grading.comment.blank? then
	  comment = ""
	else
	  comment = current_grading.comment
	end
      end


      row = []
      row << person.name.to_s + "\n <em>" + birthday + "</em>"
      row << "P: " + person.phone.to_s + "\n" + "M: " + person.mobile.to_s
      row << grading_desc + "\n <em>" + grading_date + "</em>"
#      row << trainings + "\n" + graded_since
      row << comment # Kommentar-Platzhalter
      table_content << row
    end

    table(table_content, :header => true, :row_colors => ["F0F0F0", "FFFFFF"], :cell_style => { :inline_format => true }, :column_widths => {3 => 200})

    render
  end



end
