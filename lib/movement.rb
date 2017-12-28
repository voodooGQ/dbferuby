# frozen_string_literal: true

class Movement
  def self.call(player, x: 0, y: 0)
    area = player.room.area
    current_coords = {x: player.room.x_coord, y: player.room.y_coord}
    index_range = area.coord_index_range

    dest_x = coord_loop((current_coords[:x] + x), index_range)
    dest_y = coord_loop((current_coords[:y] + y), index_range)

    destination = area.room_by_coords(dest_x, dest_y)
    return player.room = destination if destination

    raise Errors::MissingRoom, "#{dest_x}, #{dest_y} coordinates do not " \
      "exist in area #{area.name}"
  end

  private

  # @TODO: Fix
  def self.coord_loop(dest_coord, index_range)
    if dest_coord >= index_range.min && dest_coord <= index_range.max
      return dest_coord
    end

    if dest_coord < index_range.min
      index_range.max - (index_range.min - x)
    elsif dest_coord > index_range.max
      index_range.min + (index_range.max + x)
    end
  end
end
