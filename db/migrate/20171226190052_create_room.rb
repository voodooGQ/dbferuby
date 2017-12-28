class CreateRoom < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.integer :x_coord
      t.integer :y_coord
    end
  end
end
