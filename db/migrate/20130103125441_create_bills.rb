class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :prefix
      t.string :nr
      t.string :firstname
      t.string :lastname

      t.string :salutation
      t.string :bill_firstname
      t.string :bill_lastname
      t.string :bill_street
      t.string :bill_zipcity

      t.string :text1
      t.string :amount1
      t.string :text2
      t.string :amount2
      t.string :text3
      t.string :amount3
      t.string :text4
      t.string :amount4
      t.string :total
      t.date :issue_date
      t.date :paied_date
      t.string :paied_amount
      t.text :freetext

      t.text :comment
      t.string :bill_type

      t.references :person

      t.timestamps
    end
  end
end
