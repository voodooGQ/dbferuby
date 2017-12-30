# frozen_string_literal: true
require_relative "command_base"

module Commands
  class MovementBase < CommandBase
    private

    def process_move(x: 0, y: 0, exit_dir: "East", enter_dir: "West")
      if destination = Movement.linear(@initiator, x: x, y: y)
        @initiator.roommates.each do |p|
          p.send_data "\n#{@initiator.name} exits #{exit_dir}.\n"
        end

        @initiator.room = destination
        @initiator.save!
        Look.new(@initiator).call

        @initiator.roommates.each do |p|
          p.send_data "\n#{@initiator.name} enters from the #{enter_dir}.\n"
        end
      else
        @initiator.send_data "You can't go that way!\n"
      end
    end
  end
end
