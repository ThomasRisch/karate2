class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_name
      t.text :course_desc
      t.date :course_start
      t.date :course_end

      t.timestamps
    end
  end
end
