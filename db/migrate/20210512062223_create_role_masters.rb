class CreateRoleMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :role_masters do |t|
      t.text :content
      t.string :abrev
      t.text :description

      t.timestamps
    end
    add_index :role_masters, [:content, :created_at]
  end
end
