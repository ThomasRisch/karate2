# encoding: utf-8
module GradingsHelper
  #Helpers for list, show
  def grade_column(record)
    h(Grade.find(record.grade_id).name + ' - ' + Grade.find(record.grade_id).color)
  end

  #Helpers for update, create
  def grade_form_column(record, input_name)
    if record.grade_id
      h(Grade.find(record.grade_id).name + ' - ' + Grade.find(record.grade_id).color)
    else
      #new grade
      h("Neue Prüfung")
    end
  end

  # Form override (nicer formatting)
  def comment_form_column(record, input_name)
    text_area :record , :comment, :cols => 37, :rows => 6
  end
  def positive_form_column(record, input_name)
    text_area :record , :positive, :cols => 37, :rows => 6
  end
  def negative_form_column(record, input_name)
    text_area :record , :negative, :cols => 37, :rows => 6
  end


end
