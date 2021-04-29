# frozen_string_literal: true
require_relative "command_base"

module Commands
  class MovementBase < CommandBase
    def help
      syntax = "Syntax".colorize(:red)
      <<~HELP
        #{"Syntax".red}: north
        #{"Syntax".red}: northeast
        #{"Syntax".red}: northwest
        #{"Syntax".red}: south
        #{"Syntax".red}: southeast
        #{"Syntax".red}: southwest
        #{"Syntax".red}: east
        #{"Syntax".red}: west

        Use these commands to exit the current room in a particular direction.
      HELP
    end

    private

    def process_move(x: 0, y: 0, exit_dir: "East", enter_dir: "West")
      if destination = Movement.linear(@initiator, x: x, y: y)
        @initiator.roommates.each do |p|
          p.send_data "\n#{@initiator.name.red} exits #{exit_dir}.\n" if p.is_player?
        end

        @initiator.room = destination
        @initiator.save!
        Look.new(@initiator).call

        @initiator.roommates.each do |p|
          if p.class == "Player"
          p.send_data "\n#{@initiator.name.red} enters from the #{enter_dir}.\n" if p.is_player?
          end
        end
      else
        @initiator.send_data "You can't go that way!\n"
      end
    end
  end
end
