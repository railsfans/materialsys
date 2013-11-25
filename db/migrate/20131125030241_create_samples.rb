class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :name
      t.string :footprint
      t.integer :quantity
      t.text :comment
      t.string :manufacturer
      t.integer :samplefileid
      t.string :partnum

      t.timestamps
    end
  end
end
