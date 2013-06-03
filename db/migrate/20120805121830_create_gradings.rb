class CreateGradings < ActiveRecord::Migration
  def change
    create_table :gradings do |t|
      t.date :grading_date
      t.text :positive
      t.text :negative
      t.text :comment
      t.references :person
      t.references :grade

      t.timestamps
    end
  end
end
