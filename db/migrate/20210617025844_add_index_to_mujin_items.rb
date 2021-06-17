class AddIndexToMujinItems < ActiveRecord::Migration[6.1]
  def change
    add_index :mujin_items, [:mujin_id, :created_at]
  end
end
