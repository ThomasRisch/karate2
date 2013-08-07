class AddCourseAmountToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_amount, :string
  end
end
