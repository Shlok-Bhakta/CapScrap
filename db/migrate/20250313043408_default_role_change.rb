class DefaultRoleChange < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :role_id, :bigint, default: 1
  end
end
