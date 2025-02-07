class CreateExamples < ActiveRecord::Migration[8.0]
  def change
    create_table :examples do |t|
      t.string :name

      t.timestamps
    end
  end
end
