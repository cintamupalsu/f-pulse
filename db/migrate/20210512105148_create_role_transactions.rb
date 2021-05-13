class CreateRoleTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :role_transactions do |t|
      t.references :role_master, null: false, foreign_key: true
      t.references :feature_master, null: false, foreign_key: true

      t.timestamps
    end
    add_index :role_transactions, [:role_master, :feature_master]
  end
end
