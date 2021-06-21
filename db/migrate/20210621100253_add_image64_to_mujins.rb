class AddImage64ToMujins < ActiveRecord::Migration[6.1]
  def change
    add_column :mujins, :image64, :text
  end
end
