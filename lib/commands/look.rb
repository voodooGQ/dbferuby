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
    end

    private

    def location_data
      "(#{@area.name}) [#{@room.x_coord}, #{@room.y_coord}]"
    end
  end
end
