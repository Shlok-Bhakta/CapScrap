class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.references :category, null: false, foreign_key: true
      t.string :description
      t.string :location

      t.timestamps
    end
  end
end
