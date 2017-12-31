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
  attr_accessor :cached_rooms

  has_many :rooms
  validates :dimension, presence: true, numericality: {
    odd: true, greater_than_or_equal_to: 15, less_than_or_equal_to: 101
  }

  after_create :create_rooms

  def rooms
    Game.instance.world[:rooms].values || super
    #@cached_rooms ||= super
  end

  def coord_index_range
    zero_offset = dimension.divmod(2).first
    (-(zero_offset)..zero_offset)
  end

  def center_room
    @center_room ||= rooms.detect{|r| r.y_coord == 0 && r.x_coord == 0}
  end

  def room_by_coords(x = 0, y = 0)
    rooms.detect{|room| room.x_coord == x && room.y_coord == y}
  end

  def map
    @map ||= Map.new(self)
  end

  private

  def create_rooms
    grid_coord_index = -(dimension.divmod(2).first)

    dimension.times do |y_index|
      dimension.times do |x_index|
        rooms << Room.create!(
          override: true,
          y_coord: grid_coord_index + y_index,
          x_coord: grid_coord_index + x_index,
          area: self,
          sector: Sector.first
        )
      end
    end
  end
end
