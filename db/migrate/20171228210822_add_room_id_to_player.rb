class AddRoomIdToPlayer < ActiveRecord::Migration[5.1]
  def up
    add_column :players, :room_id, :integer, null: false, default: 1
  end

  def down
    remove_column :players, :room_id
  end
end
