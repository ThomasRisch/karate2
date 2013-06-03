class CreateCoursesPeopleTable < ActiveRecord::Migration
  def up
    create_table :courses_people, :id => false do |t|
      t.references :course
      t.references :person
    end
  end

  def down
    drop_table :courses_people
  end
end
