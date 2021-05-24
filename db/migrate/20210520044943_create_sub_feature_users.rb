class CreateSubFeatureUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_feature_users do |t|
      t.boolean :active
      t.references :sub_feature_master, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sub_feature_users, [:user_id, :sub_feature_master_id]
  end
end
