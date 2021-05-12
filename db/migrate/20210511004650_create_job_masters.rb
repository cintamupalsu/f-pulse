class CreateJobMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :job_masters do |t|
      t.text :content
      t.string :order

      t.timestamps
    end
    add_index :job_masters, [:order, :created_at]
  end
end
