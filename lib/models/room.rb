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

  def self.create(override: false, **args, &block)
    return super(args, &block) if override
    puts "Only Area objects should create their own Room objects to ensure " \
      "proper data integrity. You may pass an 'override' option set to true " \
      "for this method to force a creation if you understand fully what you " \
      "are doing."
  end

  def self.create!(override: false, **args, &block)
    return super(args, &block) if override
    puts "Only Area objects should create their own Room objects to ensure " \
      "proper data integrity. You may pass an 'override' option set to true " \
      "for this method to force a creation if you understand fully what you " \
      "are doing."
  end
end
