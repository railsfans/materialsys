class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :manager
      t.text :describes
      t.string :menber

      t.timestamps
    end
  end
end
