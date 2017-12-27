class AddAreaIdToRooms < ActiveRecord::Migration[5.1]
  def up
    add_column :rooms, :area_id, :integer
  end

  def down
    remove_column :rooms, :area_id
  end
end
