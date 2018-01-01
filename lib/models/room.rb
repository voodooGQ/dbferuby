# frozen_string_literal: true
#
# == Schema Information
#
# Table name: rooms
#
#  id        :integer          not null, primary key
#  x_coord   :integer
#  y_coord   :integer
#  sector_id :integer
#  area_id   :integer
#

require "active_record"

class Room < ActiveRecord::Base
  CREATION_ERROR_MSG = <<-MSG
    Only Area objects should create their own Room objects to ensure proper
    data integrity. You may pass an 'override' option set to true for this
    method to force a creation "if you understand fully what you are doing.
  MSG

  validate :unique_coordinates_by_area
  validates :x_coord, presence: true
  validates :y_coord, presence: true

  belongs_to :area, required: true
  belongs_to :sector, required: true

  has_many :occupants, foreign_key: "room_id", class_name: "Player"

  def area
    Game.instance.world.areas[area_id]["area"] || Area.find(area_id)
  end

  def connected_occupants
    Game.instance.players.select{|p| p.room_id == id}
  end

  def occupied?
    connected_occupants.any?
  end

  def unique_coordinates_by_area
    rooms = area.rooms.select do |room|
      room.x_coord == x_coord && room.y_coord == y_coord
    end

    if rooms.any? && !rooms.include?(self)
      errors.add(:x_coord, "and Y coord already exist in Area (#{area.name})")
    end
  end

  def self.create(override: false, **args, &block)
    return super(args, &block) if override
    raise Errors::UnadvisedRoomCreation, CREATION_ERROR_MSG
  end

  def self.create!(override: false, **args, &block)
    return super(args, &block) if override
    raise Errors::UnadvisedRoomCreation, CREATION_ERROR_MSG
  end
end
