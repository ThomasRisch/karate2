class AddSortToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :sort_order, :integer
    add_column :grades, :next_grade, :integer
  end
end
