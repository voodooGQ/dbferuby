# frozen_string_literal: true

class World < Hash
  attr_accessor :areas

  def initialize
    @areas = {}
    build
  end

  def rooms
    areas.each_with_object({}) do |(area_key, area_value), room_hash|
      area_value.dig("rooms").each do |room_key, room_value|
        room_hash[room_key] = room_value
      end
    end
  end

  def build
    Area.all.each do |area|
      @areas[area.id] = {}
      @areas[area.id]["area"] = area
      @areas[area.id]["rooms"] = {}
    end

    Room.all.each do |room|
      @areas[room.area_id]["rooms"][room.id] = room
    end
  end
end
