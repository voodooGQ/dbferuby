# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Look < CommandBase
    attr_reader :room, :area

    def call(*args)
      @room = @initiator.room
      @area = room.area
      @initiator.send_data(area.map.show(room, 11, 25))
      @initiator.send_data(location_data)
      @initiator.send_data(room_data)
    end

    private

    def location_data
      "(#{@area.name}) [#{@room.x_coord}.#{@room.y_coord}]\n\n"
    end

    def room_data
      @initiator.roommates.each do |player|
        @initiator.send_data "#{player.name.red} stands here."
      end
      nil
    end
  end
end
