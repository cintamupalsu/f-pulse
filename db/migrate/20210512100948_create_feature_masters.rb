class CreateFeatureMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_masters do |t|
      t.text :content
      t.string :abrev

      t.timestamps
    end
    add_index :feature_masters, [:content, :created_at]
  end
end
