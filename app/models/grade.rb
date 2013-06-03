class Grade < ActiveRecord::Base
  attr_accessible :color, :name, :sort

  has_many :gradings

end
