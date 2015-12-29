# encoding: utf-8

class BillReport < Prawn::Document
  def to_pdf(bill_array)

    pdf = Prawn::Document.new :page_size => 'A4'
    first = true 

    bill_array.each do |bill|

    !first ? pdf.start_new_page : first=false

    # Constants on page style
    pg_left = 50
    pg_right = pdf.bounds.width - 50
    pg_top = pdf.bounds.height
    pg_white = "ffffff"
    pg_black = "000000"
    pg_blue = "0276fd"
    # located in ~/.rvm/gems/ruby-1.9.3-p194/gems/prawn-0.12.0/
    pg_bold = "#{Prawn::BASEDIR}/data/fonts/Ftb_____.ttf"
    pg_light = "#{Prawn::BASEDIR}/data/fonts/Ftl_____.ttf"
    pg_ocr = "#{Prawn::BASEDIR}/data/fonts/OCRB.ttf"
    pdf.font_size 12


    # Vorbereiten Rechnunsbeschriftung

    # Betrag
    betrStr = bill.total
    b = 100
    betr = '01' + "%010d" % (betrStr.to_f*b).to_i
    betr = betr + mod10(betr).to_s + '>'
    betr_fr, betr_rp = bill.total.split('.')

    # Adressen
    if bill.company.blank? or bill.company == "Keiko Kan" then

      # Bankverbindung 
      bank_str = "RAIFFEISEN Mutschellen-Reppischtal\n8965 Mutschellen"
      adr_str = "Olivia Derungs Risch\nKeiko Kan\nKirchgasse 23\n8903 Birmensdorf" 
      kto_str = "01-9883-7"

      # für EZ-Nummer
      prefix = bill.prefix
      nr = bill.nr
      ident = '7394638067300' + prefix + nr
      ident = ident + mod10(ident).to_s
      ident_friendly = ident.reverse.scan(/.{1,5}/).join(' ').reverse
      ident_short = ident
      ident = ident + '+ '
      kto = "010098837>"


      # Bilder, Logos, Corporate Identity
      # Prawn::BASEDIR = /home/thomas/.rvm/gems/ruby-1.9.3-p194/gems/prawn-0.12.0
      pdf.image "#{Prawn::BASEDIR}/data/images/keikokan_karate.png", :position=>:left, :width=>220, :at => [pg_left - 18, pg_top-37]
      absender = "Keiko Kan, Kirchgasse 23, 8903 Birmensdorf"

    elsif bill.company == "Hühner-Rei"

      # Bankverbindung
      bank_str = "UBS AG\n8903 Birmensdorf"
      adr_str = "Olivia Derungs Risch\nKirchgasse 23\n8903 Birmensdorf"
      kto_str = "80-2-2"

      # keine EZ Nummer
      betr = kto = ident = ident_friendly = ident_short = ""

      # Bilder, Logos, Corporate Identity
      pdf.image "#{Prawn::BASEDIR}/data/images/huehnerlogo.png", :position=>:left, :width=>100, :at => [pg_left, pg_top-37]
      absender = "Hühner-Rei\nOlivia Derungs Risch, Kirchgasse 23, 8903 Birmensdorf"

    end

    # Address
    pdf.bounding_box([pg_left + 270, pg_top-100], :width => pg_right) do
      pdf.text absender, :size => 6
      pdf.text "\n" 
      if not bill.salutation.blank? then
        pdf.text bill.salutation
      end
      pdf.text bill.bill_firstname + " " + bill.bill_lastname
      pdf.text bill.bill_street
      pdf.text bill.bill_zipcity
      pdf.text "\n\n"

      @current_y = (pg_top-100) - pdf.bounds.height
    end

    pdf.bounding_box [pg_left,@current_y], :width => pg_right-(pg_left) do
      pdf.font pg_light
      # uses i18l API, configured to :de in environment.rb (http://guides.rubyonrails.org/i18n.html)
      # as we are in the helper here, it must be spelled out I18n.l; in controler l is sufficient.
      pdf.text I18n.l(bill.issue_date, :format => :long)
      pdf.text " "
      pdf.text " "
      pdf.font pg_bold
      if !bill.prefix.blank? and !bill.nr.blank? then
        pdf.text bill.bill_type + " Nr. " + bill.prefix + " " + bill.nr
      else
        pdf.text bill.bill_type 
      end

      pdf.font pg_light
      pdf.text " "
      pdf.text "für " + bill.firstname + " " + bill.lastname
      pdf.text "\n"
      @current_y = (pg_top-200) - pdf.bounds.height
    end


    # Bill Lines
    pdf.bounding_box [pg_left,@current_y], :width => (350-5) do
      pdf.horizontal_rule
      pdf.text "\n", :size => 3
      if not bill.text1.blank? then
        pdf.text bill.text1
      end
      if not bill.text2.blank? then
        pdf.text bill.text2
      end
      if not bill.text3.blank? then
        pdf.text bill.text3
      end
      if not bill.text4.blank? then
        pdf.text bill.text4
      end
      pdf.text "\n", :size => 3
      pdf.horizontal_rule
      pdf.font pg_bold
      #for whatever reason the tab \t is only working when placed within the string.
      #space is not working at all.
      pdf.text "\n", :size => 6
      pdf.text "Total", :align => :right
      pdf.font pg_light
      pdf.text "\n"
      pdf.text "Zahlbar innert 30 Tagen."
      pdf.text "\n"

      @next_y = @current_y - pdf.bounds.height

    end

    pdf.bounding_box [pg_left+350,@current_y], :width => pg_right-(pg_left+350) do
      pdf.horizontal_rule
      pdf.text "\n", :size => 3
      if not bill.text1.blank? then
        pdf.text "Fr."
      end
      if not bill.text2.blank? then
        pdf.text "Fr."
      end
      if not bill.text3.blank? then
        pdf.text "Fr."
      end
      if not bill.text4.blank? then
        pdf.text "Fr."
      end
      pdf.text "\n", :size => 3
      pdf.horizontal_rule
      pdf.font pg_bold
      pdf.text "\n", :size => 6
      pdf.text "Fr."
      pdf.font pg_light
    end
    pdf.bounding_box [pg_left+370,@current_y], :width => pg_right-(pg_left+370) do
      pdf.horizontal_rule
      pdf.text "\n", :size => 3
      if not bill.text1.blank? then
        pdf.text bill.amount1, :align => :right
      end
      if not bill.text2.blank? then
        pdf.text bill.amount2, :align => :right
      end
      if not bill.text3.blank? then
        pdf.text bill.amount3, :align => :right
      end
      if not bill.text4.blank? then
        pdf.text bill.amount4, :align => :right
      end
      pdf.text "\n", :size => 3
      pdf.horizontal_rule
      pdf.font pg_bold
      pdf.text "\n", :size => 6
      pdf.text bill.total, :align => :right
      pdf.font pg_light
    end
    @current_y = @next_y

    # greetings
    pdf.bounding_box [pg_left,@current_y], :width => (pg_right-pg_left) do

      if not bill.freetext.blank?
        pdf.text bill.freetext
      else
        pdf.text "\n"
      end
      pdf.text "\n"

      if bill.bill_type == "Rechnung" then
        pdf.text "Herzlichen Dank für das Vertrauen."
        pdf.text "\n"
      end
      pdf.text "Mit freundlichen Grüssen"
      pdf.font pg_bold
      pdf.text "Olivia Derungs Risch"
      pdf.font pg_light
    end

    # EZ

    # Adressen
    pdf.font_size 9
    pdf.bounding_box [-10,230], :width=>150 do
      pdf.text bank_str
    end
    pdf.bounding_box [-10,190], :width=>150 do
      pdf.text adr_str
    end
    pdf.bounding_box [165,230], :width=>150 do
      pdf.text bank_str
    end
    pdf.bounding_box [165,190], :width=>150 do
      pdf.text adr_str
    end

    # Betrag
    pdf.font pg_ocr
    pdf.font_size 10
    pdf.bounding_box [58,110], :width=>80 do
      pdf.text betr_fr + "   " + betr_rp
    end
    pdf.bounding_box [233,110], :width=>80 do
      pdf.text betr_fr + "   " + betr_rp
    end

    # Kontonummer
    pdf.font pg_light
    pdf.font_size 9
    pdf.bounding_box [42,133], :width=>50 do
      pdf.text kto_str
    end
    pdf.bounding_box [217,133], :width=>50 do
      pdf.text kto_str
    end

    # Kundenadressen
    pdf.bounding_box [-10,78], :width=>140 do
      pdf.text ident_short
      pdf.text "\n"
      pdf.text bill.bill_firstname + " " + bill.bill_lastname
      pdf.text bill.bill_street
      pdf.text bill.bill_zipcity
    end
    pdf.bounding_box [335,110], :width=>140 do
      pdf.text "\n"
      pdf.text "\n"
      pdf.text bill.bill_firstname + " " + bill.bill_lastname
      pdf.text bill.bill_street
      pdf.text bill.bill_zipcity
    end


    # Nummern
    pdf.font pg_ocr
    pdf.font_size 10
    pdf.bounding_box [25,161], :width => (pg_right+55) do
      pdf.text ident_friendly, :align => :right
    end

    # Full Number at the bottom (10 is absolute minimum... tested 2015)
    pdf.bounding_box [20,10], :width => (pg_right+50) do
      pdf.text betr + ident + kto, :align => :right
    end

    end # loop over bill_array

    pdf.render

  end


  def mod10 (number) 
    # see http://www.hosang.ch/modulo10.aspx

    tabelle = [0, 9, 4, 6, 8, 2, 7, 1, 3, 5]
    uebertrag = 0
    nums = number.to_s.split("")
  
    nums.each do |n|
      uebertrag = tabelle[(n.to_i + uebertrag.to_i) % 10]
    end

    return (10 - uebertrag.to_i) % 10
  end
end
