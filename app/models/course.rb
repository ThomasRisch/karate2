class Course < ActiveRecord::Base
  has_and_belongs_to_many :people
  attr_accessible :course_end, :course_start, :course_desc, :course_name

  def to_label
    "#{course_name}"
#    "#{course_name} (#{course_start} - #{course_end})"
  end
end
