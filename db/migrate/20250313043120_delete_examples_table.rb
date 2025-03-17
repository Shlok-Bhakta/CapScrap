class DeleteExamplesTable < ActiveRecord::Migration[8.0]
  def change
    connection.execute 'drop table if exists examples'
  end
end
