# frozen_string_literal: true
require "active_record"

class Room < ActiveRecord::Base
  #has_many :rooms_sectors, class_name: "RoomSector"
  #has_many :sectors, :through => :rooms_sectors
  belongs_to :sector
end
