class AddActiveToRoleTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :role_transactions, :active, :bool
  end
end
