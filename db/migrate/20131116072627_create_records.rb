class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :people
      t.string :situ
      t.string :rlocation
      t.string :date

      t.timestamps
    end
  end
end
