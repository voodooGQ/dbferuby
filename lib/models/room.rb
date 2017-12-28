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

  def unique_coordinates_by_area
    if area.rooms.where("x_coord = ? AND y_coord = ?", x_coord, y_coord).any?
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
