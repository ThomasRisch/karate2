class Grading < ActiveRecord::Base
  attr_accessible :comment, :grading_date, :negative, :positive

  belongs_to :person
  belongs_to :grade

  def to_label
    ""
  end
end
