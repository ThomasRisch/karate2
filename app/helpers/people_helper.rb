# encoding: utf-8
module PeopleHelper

  def person_image_show_column(record)
    image_tag record.image_url(:thumb).to_s
  end

  def salutation_form_column(record, options)
    select :record, :salutation, ["Herr", "Frau", "Familie"]
  end


end
