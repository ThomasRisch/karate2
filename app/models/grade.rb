class Grade < ActiveRecord::Base
  attr_accessible :color, :name, :sort_order, :next_grade

  has_many :gradings

end
