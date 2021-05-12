class CreateGoodMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :good_masters do |t|
      t.text :content
      t.string :order

      t.timestamps
    end
    add_index :good_masters, [:order, :created_at]
  end
end
