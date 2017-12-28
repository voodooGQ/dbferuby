class AddDimensionToArea < ActiveRecord::Migration[5.1]
  def up
    add_column :areas, :dimension, :integer, null: false, default: 15
  end

  def down
    remove_column :areas, :dimension
  end
end
