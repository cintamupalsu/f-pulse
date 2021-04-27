class CreateMujinItems < ActiveRecord::Migration[6.1]
  def change
    create_table :mujin_items do |t|
      t.string :name
      t.float :stock
      t.float :price
      t.references :mujin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
