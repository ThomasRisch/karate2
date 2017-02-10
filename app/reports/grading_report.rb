# encoding: utf-8

class GradingReport < Prawn::Document
  def to_pdf(person_id)
 
    person = Person.find(person_id)
    gradings = Grading.where(person_id: person_id)

    title = "Details für " + person.firstname.to_s + " " + person.lastname.to_s

    font_size 24
    text title
    font_size 10

    table_content = [["<b>Grad</b>", "<b>seit</b>", "<b>Komm.</b>", "<b>Positiv</b>", "<b>Negativ</b>"]]

    gradings.each do |grading|

      # Potential for optimization...
      grade = Grade.find(grading.grade_id)
      grading_desc = grade.name + "\n" + grade.color

      row = []
      row << grading_desc
      row << I18n.l(grading.grading_date).to_s
      row << grading.comment
      row << grading.positive
      row << grading.negative

      table_content << row

    end

    table(table_content, :header => true, :row_colors => ["F0F0F0", "FFFFFF"], :cell_style => { :inline_format => true })
    render

  end

end
