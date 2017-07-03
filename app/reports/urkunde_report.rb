# encoding: utf-8

class UrkundeReport < Prawn::Document
#  def to_pdf(lastname, vorname, date, kyu, color)
  def to_pdf(ur_array)

    pdf = Prawn::Document.new :page_size => 'A4'
    first = true

    ur_array.each do |ur|

    !first ? pdf.start_new_page : first=false

    # Constants on page style
    pg_left = 50
    pg_right = pdf.bounds.width - 50
    pg_center = pdf.bounds.width / 2
    pg_top = pdf.bounds.height
    pg_white = "ffffff"
    pg_black = "000000"
    pg_blue = "0276fd"
    # located in ~/.rvm/gems/ruby-1.9.3-p194/gems/prawn-0.12.0/
    #rootpath = "#{Prawn::BASEDIR}"
    pg_bold = "#{Rails.root}/app/assets/fonts/Ftb_____.ttf"
    pg_light = "#{Rails.root}/app/assets/fonts/Ftl_____.ttf"
    pg_ocr = "#{Rails.root}/app/assets/fonts/OCRB.ttf"
    pdf.font_size 13


    case ur[:color] 
    when "Halbgelbgurt"
      img = "kk_yellow.png"
    when "Halborangegurt"
      img = "kk_orange.png"
    when "Halbgrüngurt"
      img = "kk_green.png"
    when "Halbblaugurt"
      img = "kk_blue.png"
    when "Halbviolett"
      img = "kk_violett.png"
    else
      img = "kk_gray.png"
    end
    pdf.image "#{Rails.root}/app/assets/images/"+img, :position=>:left, :at => [pg_left-45, pg_top-25]


    pdf.move_down 20
    pdf.font pg_bold
    pdf.text "Urkunde", :size  => 72, :align => :center

    pdf.move_down 50 
    pdf.text ur[:firstname] + " " + ur[:lastname], :size => 36, :align => :center

    pdf.move_down 75
    pdf.font pg_light
    pdf.text "hat die Karateprüfung zum", :size => 18, :align => :center

    pdf.move_down 75
    pdf.font pg_bold
    pdf.text ur[:color] + ", " + ur[:kyu], :size => 36, :align => :center

    pdf.move_down 75
    pdf.font pg_light
    pdf.text "erfolgreich bestanden.", :size => 18, :align => :center

    pdf.image "#{Rails.root}/app/assets/images/kk_logo.png", :position=>:left, :at => [pg_left-50, 110]


    pdf.bounding_box [pg_center+40,140], :width => pg_right-(pg_center+20) do

      # uses i18l API, configured to :de in environment.rb (http://guides.rubyonrails.org/i18n.html)
      # as we are in the helper here, it must be spelled out I18n.l; in controler l is sufficient.
      pdf.text I18n.l(ur[:date], :format => :long)

      pdf.move_down 40
      pdf.text "Olivia Derungs Risch"

      pdf.move_down 40
      pdf.text "Thomas Risch"

    end

    end # loop over urkunden

    pdf.render
  end
end


