class CreateNpc < ActiveRecord::Migration[5.2]
  def change
    create_table :npcs do |t|
      t.string  :name
      t.string  :password
      t.string  :race
      t.boolean :flying
      t.integer :room_id
      t.integer :starting_area_id
      t.integer :starting_room_id
    end
  end
end
