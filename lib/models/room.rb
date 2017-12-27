# frozen_string_literal: true
require "active_record"

class Room < ActiveRecord::Base
  validate :unique_coordinates_by_area
  validates :x_coord, presence: true
  validates :y_coord, presence: true

  belongs_to :area, required: true
  belongs_to :sector, required: true

  def unique_coordinates_by_area
    if area.rooms.where("x_coord = ? AND y_coord = ?", x_coord, y_coord).any?
      errors.add(:x_coord, "and Y coord already exist in Area (#{area.name})")
    end
  end
end
