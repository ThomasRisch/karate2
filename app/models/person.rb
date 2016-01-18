class Person < ActiveRecord::Base

  # Input from Rails book, p78, combined with Playtime excercise
#  validates_presence_of :name, :salutation, :firstname, :lastname, :street, :zipcity, :birthday, :amount, :entry_date, message: 'darf nicht leer sein.'
  validates_presence_of :name, :firstname, :lastname, :street, :zipcity, message: 'darf nicht leer sein.'
  # Required for  CarrierWave attachement handling
  mount_uploader :image, ImageUploader

  has_many :bills
  has_many :documents
  has_many :gradings
  has_many :notes
  has_and_belongs_to_many :courses

  # Pretty printing of concatinated fields
  def name
    "#{self.lastname} #{self.firstname}"
  end
  def bill_name
    "#{self.bill_lastname} #{self.bill_firstname}"
  end

  def gradex
    current_grading = Grading.find(:last, :conditions => "person_id = " + id.to_s)
    if not current_grading
      return '-'
    else
      return Grade.find(current_grading.grade_id).name + ' - ' + Grade.find(current_grading.grade_id).color + " (" + I18n.l(current_grading.grading_date) + ")"
    end
  end
  
  def notex
    all_notes = Note.find(:all, :conditions => "person_id = " + id.to_s)
    if all_notes.blank? or (all_notes.length == 0)
      return "-"
    else
      return all_notes.length.to_s
    end
  end

  def docx
    all_docs = Document.find(:all, :conditions => "person_id = " + id.to_s)
    if all_docs.blank? or (all_docs.length == 0)
      return "-"
    else
      return all_docs.length.to_s
    end
  end

  def coursex
    all_courses = Course.all(:include => :people, :conditions => "people.id = " + id.to_s)
    if all_courses.blank? or (all_courses.length == 0)
      return "-"
    else
      return all_courses.length.to_s
    end
  end

end
