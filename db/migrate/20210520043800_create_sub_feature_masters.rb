class CreateSubFeatureMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_feature_masters do |t|
      t.text :content
      t.string :abrev
      t.references :feature_master, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sub_feature_masters, [:feature_master_id, :abrev]
  end
end
