class AddCompanyToBills < ActiveRecord::Migration
  def change
    add_column :bills, :company, :string
  end
end
