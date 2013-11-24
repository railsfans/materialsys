class CreateBoms < ActiveRecord::Migration
  def change
    create_table :boms do |t|
      t.string :name
      t.string :code
      t.string :partref
      t.string :partparams
      t.string :partnum
      t.string :footprint
      t.string :manufacturer
      t.string :module
      t.string :comment
      t.integer :fileid

      t.timestamps
    end
  end
end
