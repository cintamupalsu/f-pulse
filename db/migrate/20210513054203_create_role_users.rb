class CreateRoleUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :role_users do |t|
      t.references :role_master, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
    add_index :role_users, [:role_master_id, :user_id]
  end
end
