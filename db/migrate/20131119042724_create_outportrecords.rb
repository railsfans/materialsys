class CreateOutportrecords < ActiveRecord::Migration
  def change
    create_table :outportrecords do |t|
      t.string :code
      t.string :partnum
      t.integer :quantity
      t.string :name
      t.string :date
      t.string :comment
      t.string :footprint
      t.integer :record_id

      t.timestamps
    end
  end
end
