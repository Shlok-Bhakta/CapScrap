class AddIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :identities do |t|
      t.references :user, index: true, null: false
      t.string :provider_name, null: false
      t.string :provider_uid, null: false

      t.timestamps
    end
  end
end