class NewRentingFields < ActiveRecord::Migration[8.0]
  def change
    add_column :rentings, :is_returned, :boolean, default: false
    add_column :rentings, :is_singleuse, :boolean, default: false
  end
end
