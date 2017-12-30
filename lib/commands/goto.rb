# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Goto < CommandBase
    def call(args)
      x, y, area = args.split

      area_dest = @initiator.area

      if area and
          !(area_dest = Area.where("lower(name) = ?", area.downcase).first)
        return @initiator.send_data "The planet #{area} does not exist."
      end

      unless room_dest = area_dest.room_by_coords(x.to_i, y.to_i)
        coords = area_dest.coord_index_range
        return @initiator.send_data "#{area_dest.name} does not have a room " \
          "with coords #{x}, #{y}. Area coordinate ranges span from " \
          "#{coords.min} to #{coords.max}"
      end

      process(room_dest)
    end

    def policy
      @initiator.is_admin?
    end

    private

    def process(room)
      @initiator.roommates.each do |p|
        p.send_data "\n#{@initiator.name} puts two fingers to their " \
          "forehead and snaps out of existence."
      end

      @initiator.room = room
      @initiator.save!
      Look.new(@initiator).call

      @initiator.roommates.each do |p|
        p.send_data "\n#{@initiator.name} pops into existence.\n"
      end
    end
  end
end
