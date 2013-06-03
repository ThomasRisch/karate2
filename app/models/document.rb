class Document < ActiveRecord::Base
  attr_accessible :comment, :doctype, :filename

  mount_uploader :filename, FileUploader

  belongs_to :person

  def to_label
    "#{doctype}"
  end

end
