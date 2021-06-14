class AddContentToMujins < ActiveRecord::Migration[6.1]
  def change
    add_column :mujins, :content, :text
  end
end
