class Note < ActiveRecord::Base
  belongs_to :person
  attr_accessible :note_text
end
