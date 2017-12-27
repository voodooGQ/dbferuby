class AddSectorIdToRooms < ActiveRecord::Migration[5.1]
  def up
    add_column :rooms, :sector_id, :integer
  end

  def down
    remove_column :rooms, :sector_id
  end
end
