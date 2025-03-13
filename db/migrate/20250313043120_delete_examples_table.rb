class DeleteExamplesTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :examples
  end
end
