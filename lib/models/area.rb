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
end
