# encoding: utf-8

class InvoicesReport < Prawn::Document
  def to_pdf(bill_array, bill_course)

    title = "Vorschau Rechnungen" + Course.find(bill_course).course_name
    fulltext = ""
    fullamount = ""
    fulltotal = 0.0

    font_size 24
    text title
    font_size 10

    table_content = [["<b>EZ</b>", "<b>Name</b>", "<b>Rechnungstext</b>", "<b>Betrag</b>", "<b>Total</b>"]]
    bill_array.each do |bill|    
      fulltext = ""
      fullamount = ""
      row = []
      row << bill.nr
      row << bill.lastname.to_s + ", " + bill.firstname.to_s
      fulltext = fulltext + bill.text1 if !bill.text1.blank?
      fulltext = fulltext + "\n" + bill.text2 if !bill.text2.blank?
      fulltext = fulltext + "\n" + bill.text3 if !bill.text3.blank?
      fulltext = fulltext + "\n" + bill.text4 if !bill.text4.blank?
      row << fulltext
      fullamount = fullamount + bill.amount1 if !bill.amount1.blank?
      fullamount = fullamount + "\n" + bill.amount2 if !bill.amount2.blank?
      fullamount = fullamount + "\n" + bill.amount3 if !bill.amount3.blank?
      fullamount = fullamount + "\n" + bill.amount4 if !bill.amount4.blank?
      row << fullamount
      fulltotal = fulltotal.to_f + bill.total.to_f
      row << bill.total
      table_content << row
    end

    table(table_content, :header => true, :row_colors => ["F0F0F0", "FFFFFF"], :cell_style => { :inline_format => true })
   
    text "\n\n"
    text "Totalsumme: " + fulltotal.to_s

    render
  end
end
