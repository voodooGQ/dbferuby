# frozen_string_literal: true
#
# == Schema Information
#
# Table name: areas
#
#  id        :integer          not null, primary key
#  name      :string
#  dimension :integer          default(15), not null
#

require "active_record"

class Area < ActiveRecord::Base
  has_many :rooms
  validates :dimension, presence: true, numericality: {
    odd: true, greater_than_or_equal_to: 15, less_than_or_equal_to: 101
  }

  after_create :create_rooms

  def create_rooms
    grid_coord_index = -(dimension.divmod(2).first)

    dimension.times do |y_index|
      dimension.times do |x_index|
        Room.create!(
          override: true,
          y_coord: grid_coord_index + y_index,
          x_coord: grid_coord_index + x_index,
          area: self,
          sector: Sector.find(1)
        )
      end
    end
  end

  def rooms
    # Memoize
    @rooms ||= super
  end

  def coord_indexes
    grid_coord_index = dimension.divmod(2).first
    { min: -grid_coord_index, max: grid_coord_index }
  end

  def display_area_map(center_room_id, y_viewport = 11, x_viewport = 25)
    y_viewport_range = y_viewport.divmod(2).first
    x_viewport_range = x_viewport.divmod(2).first
    center_room = rooms.detect{ |room| room.id == center_room_id }
    coord_range = (coord_indexes[:min]..coord_indexes[:max]).to_a

    y_range = coord_range.rotate(
      coord_range.index(center_room.y_coord) - y_viewport_range
    )[0..(y_viewport-1)]

    x_range = coord_range.rotate(
      coord_range.index(center_room.x_coord) - x_viewport_range
    )[0..(x_viewport-1)]

    String.new.tap do |map|
      y_range.each do |row|
        x_range.each do |column|
          room = rooms.detect{|r| r.y_coord == row && r.x_coord == column}
          map << room.sector.symbol.colorize(room.sector.color)
        end
        map << "\n"
      end
    end
  end
end
