class AddSingleUseToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :single_use, :boolean
  end
end
