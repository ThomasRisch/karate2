class Bill < ActiveRecord::Base

  belongs_to :person

#  validates_presence_of :firstname, :lastname, :bill_firstname, :bill_lastname, :bill_street, :bill_zipcity, :amount1, :line1, :total, :issue_date, message: 'darf nicht leer sein.'
  validates_presence_of :firstname, :lastname, :bill_firstname, :bill_lastname, :bill_street, :bill_zipcity, :total, :issue_date, message: 'darf nicht leer sein.'


  def to_label
    "#{bill_type}"
  end
  
  def fullnr
    if not (prefix.nil? or nr.nil?)
      "%05s" % prefix + ' ' + "%05s" % nr
    else
      "n/a"
    end
  end
  def name
    if not (lastname.nil? or firstname.nil?)
      lastname + ', ' + firstname
    else
      "n/a"
    end
  end
  def bill_name
    if not (bill_lastname.nil? or bill_firstname.nil?)
      bill_lastname + ', ' + bill_firstname
    else
      "n/a"
    end
  end

  def line1
    if not (text1.nil? or amount1.nil?)
       " Fr.%.2f" % amount1.to_s + ", " + text1
    else
      '-'
    end
  end
  def line2
    if not (text2.nil? or amount2.nil?)
       " Fr.%.2f" % amount2.to_s + ", " + text2
    else
      '-'
    end
  end
  def line3
    if not (text3.nil? or amount3.nil?)
       " Fr.%.2f" % amount3.to_s + ", " + text3
    else
      '-'
    end
  end
  def line4
    if not (text4.nil? or amount4.nil?)
       " Fr.%.2f" % amount4.to_s + ", " + text4
    else
      '-'
    end
  end
  def line_total
    if not (total.nil? or issue_date.nil?)
      "Fr. %.2f" % total.to_s + ", " + I18n.l(issue_date)
    else
      '-'
    end
  end
  def line_paied
    if not (paied_amount.nil? or paied_date.nil?)
      "Fr. %.2f" % paied_amount.to_s + ", " + I18n.l(paied_date)
    else
      '-'
    end
  end


  def authorized_for_pay?
    if not paied_amount.blank?
      false
    else
      true
    end
  end


end
