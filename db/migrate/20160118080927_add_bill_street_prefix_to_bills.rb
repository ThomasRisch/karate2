class AddBillStreetPrefixToBills < ActiveRecord::Migration
  def change
    add_column :bills, :bill_streetprefix, :string
  end
end
