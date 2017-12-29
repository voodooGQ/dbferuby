# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Goto < CommandBase
    def call(args)
      x, y, area = args
      area_dest = @initiator.area

      if area
        unless area_dest = Area.find_by_name(area)
          return @initiator.send "The planet #{area} does not exist."
        end
      end

      unless room_dest = area_dest.room_by_coords(x.to_i, y.to_i)
        coords = area.coord_index_range
        return player.send "#{area.name} does not have a room with coords " \
          "#{x}, #{y}. Area coordinate ranges span from #{coords.min} to " \
          "#{coords.max}"
      end

      @initiator.roommates.each do |p|
        p.send_data "\n#{@initiator.name} puts two fingers to their " \
          "forehead and snaps out of existence."
      end

      @initiator.room = room_dest
      @initiator.save!
      Look.new(@initiator).call

      @initiator.roommates.each do |p|
        p.send_data "\n#{@initiator.name} pops into existence.\n"
      end
    end

    def policy
      @initiator.is_admin?
    end
  end
end
