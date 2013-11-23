class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :name
      t.string :code
      t.integer :parent_id
      t.string :footprint
      t.string :partnum
      t.string :flocation
      t.string :partparams

      t.timestamps
    end
  end
end
