class AddBillStreetPrefixToPeople < ActiveRecord::Migration
  def change
    add_column :people, :bill_streetprefix, :string
  end
end
