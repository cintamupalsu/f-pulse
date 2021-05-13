class AddMasterToFeatureMasters < ActiveRecord::Migration[6.1]
  def change
    add_column :feature_masters, :master, :bool
  end
end
