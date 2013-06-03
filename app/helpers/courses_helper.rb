module CoursesHelper
  # Form override (nicer formatting)
  def course_desc_form_column(record, input_name)
    text_area :record , :course_desc, :cols => 37, :rows => 6
  end

end
