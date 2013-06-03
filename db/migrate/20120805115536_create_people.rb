class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :lastname
      t.string :firstname
      t.string :street
      t.string :zipcity
      t.string :phone
      t.string :mobile
      t.string :email
      t.date :birthday

      t.string :image

      t.string :salutation
      t.string :bill_firstname
      t.string :bill_lastname
      t.string :bill_street
      t.string :bill_zipcity
      t.string :bill_email

      t.date :entry_date
      t.date :leave_date

      t.float :amount
      t.float :discount
      t.boolean :is_yearly

      t.timestamps
    end
  end
end
