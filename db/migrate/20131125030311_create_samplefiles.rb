class CreateSamplefiles < ActiveRecord::Migration
  def change
    create_table :samplefiles do |t|
      t.string :filename
      t.integer :project_id

      t.timestamps
    end
  end
end
