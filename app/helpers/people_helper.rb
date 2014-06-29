# encoding: utf-8
module PeopleHelper

  def person_image_show_column(record)
    image_tag record.image_url(:thumb).to_s
  end

  def salutation_form_column(record, options)
    select :record, :salutation, ["Herr", "Frau", "Familie"]
  end

  def options_for_association_conditions(association)
    if association.name == :courses
      ['courses.id in (?)', Course.where("courses.course_end IS NULL or courses.course_end > ?", Date.today)]
    else
      super
    end
  end



end
