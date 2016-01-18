# encoding: utf-8
module GradingsHelper
  #Helpers for list, show
  def grade_column(record)
    h(Grade.find(record.grade_id).name + ' - ' + Grade.find(record.grade_id).color)
  end

  #Helpers for update, create
  def grade_form_column(record, input_name)
    if record.grade_id
#      h(Grade.order("sort_order").find(record.grade_id).name + ' - ' + Grade.order("sort_order").find(record.grade_id).color)
    h(Grade.find(record.grade_id).name + ' - ' + Grade.find(record.grade_id).color)
    else
      #new grade
      h("Neue Prüfung")
    end
  end

end
