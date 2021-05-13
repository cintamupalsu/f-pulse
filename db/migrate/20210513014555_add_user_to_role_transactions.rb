class AddUserToRoleTransactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :role_transactions, :user, null: false, foreign_key: true
  end
end
