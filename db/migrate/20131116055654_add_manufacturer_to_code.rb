class AddManufacturerToCode < ActiveRecord::Migration
  def up
	add_column :codes, :manufacturer, :string
  end

  def down
	remove_column :codes, :manufacturer
  end
end
