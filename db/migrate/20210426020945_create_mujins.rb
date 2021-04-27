class CreateMujins < ActiveRecord::Migration[6.1]
  def change
    create_table :mujins do |t|
      t.string :name
      t.float :lat
      t.float :lon
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
