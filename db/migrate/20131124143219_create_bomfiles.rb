class CreateBomfiles < ActiveRecord::Migration
  def change
    create_table :bomfiles do |t|
      t.string :filename
      t.integer :project_id

      t.timestamps
    end
  end
end
