class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :code
      t.integer :currentquantity
      t.integer :originquantity
      t.text :comment
      t.string :name
      t.float :unitprice
      t.integer :record_id
      t.string :partnum
      t.string :footprint
      t.string :manufacturer
      t.string :partparams
      t.string :supplier
      t.datetime :importtime

      t.timestamps
    end
  end
end
