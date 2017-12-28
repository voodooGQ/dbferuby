# frozen_string_literal: true

class Map
  def initialize(area)
    @area = area
  end

  def show(center_room = @area.center_room, height = 11, width = 25)
    String.new.tap do |map|
      centered_coordinates(center_room.y_coord, height).each do |y|
        centered_coordinates(center_room.x_coord, width).each do |x|
          sector = @area.room_by_coords(x, y).sector
          map << sector.symbol.colorize(sector.color)
        end
        map << "\n"
      end
    end
  end

  private

  def coordinate_index_array
    @area.coord_index_range.to_a if @area.respond_to?(:coord_index_range)
  end

  def centered_coordinates(center_coord, view_range)
    offset = view_range.divmod(2).first
    coords = coordinate_index_array
    # Make sure we have enough items in the coord array
    coords.push(*coords) while coords.count < view_range
    coords.rotate(coords.index(center_coord) - offset)[0..(view_range - 1)]
  end
end
