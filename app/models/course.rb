class Course < ActiveRecord::Base

  has_and_belongs_to_many :people

  validates_presence_of :course_desc, :course_name, :course_amount, message: 'darf nicht leer sein.'

  def to_label
    "#{course_name}"
  end
end
