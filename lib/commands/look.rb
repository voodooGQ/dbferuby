# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Look < CommandBase
    def call(*args)
      room = @initiator.room
      area = room.area
      @initiator.send_data(area.map.show(room, 11, 25))
    end
  end
end
