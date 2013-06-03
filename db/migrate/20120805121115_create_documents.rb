class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :doctype
      t.string :filename
      t.string :comment
      t.references :person

      t.timestamps
    end

    add_index :documents, :person_id

  end
end
