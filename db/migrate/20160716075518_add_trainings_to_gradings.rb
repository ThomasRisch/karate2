class AddTrainingsToGradings < ActiveRecord::Migration
  def change
    add_column :gradings, :trainings, :integer
  end
end
