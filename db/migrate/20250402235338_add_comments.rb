class AddComments < ActiveRecord::Migration[8.0]
  def change
    # add comments to purchases, rentings, and items tables
    add_column :purchases, :comments, :text
    add_column :rentings, :comments, :text
    add_column :items, :comments, :text
  end
end
