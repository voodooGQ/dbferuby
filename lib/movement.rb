# frozen_string_literal: true

class Movement
  # @return [Room] The room of destintation
  def self.linear(player, x: 0, y: 0)
    index_range = player.area.coord_index_range
    dest_x = coord_loop((player.room.x_coord + x), index_range)
    dest_y = coord_loop((player.room.y_coord + y), index_range)
    player.area.room_by_coords(dest_x, dest_y)
  end

  private

  def self.coord_loop(dest_coord, index_range)
    if dest_coord >= index_range.min && dest_coord <= index_range.max
      return dest_coord
    end

    if dest_coord < index_range.min
      index_range.max + (dest_coord - index_range.min + 1)
    elsif dest_coord > index_range.max
      index_range.min + (dest_coord - index_range.max - 1)
    end
  end
end
