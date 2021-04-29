require 'active_record'

class Character < ActiveRecord::Base
  self.abstract_class = true

  VALID_RACES = %w[saiyan human namek icer mutant android]

  validates :race, presence: true, inclusion: {
    in: VALID_RACES, message: "%{value} is not a valid race"
  }

  belongs_to :room, required: true

  def room
    Game.instance.world.rooms[room_id] || Room.find(room_id)
  end

  # Through relationship is significantly slower & this takes cache into account
  def area
    room.area
  end

  def roommates
    room.connected_occupants.reject{|o| o == self}
  end

  def areamates
    Game.instance.players.select{|p| p.area == area && p != self}
  end

  def is_player?
    self.class == 'Player'
  end
end
