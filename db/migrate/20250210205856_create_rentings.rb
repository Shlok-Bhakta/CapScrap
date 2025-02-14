class CreateRentings < ActiveRecord::Migration[8.0]
  def change
    create_table :rentings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.datetime :checkout_date
      t.datetime :return_date
      t.integer :quantity

      t.timestamps
    end
  end
end
