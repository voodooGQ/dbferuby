# frozen_string_literal: tru,
require_relative "command_base"

module Commands
  class Fly < CommandBase
    def help
      syntax = "Syntax".colorize :red
      <<~HELP
        #{"Syntax".red}: fly

        Use this command to fly into the air or float to the ground.
      HELP
    end

    def call(*args)
      @initiator.roommates.each do |p|
        if @initiator.flying
          p.send_data "\n#{@initiator.name} floats to the ground."
        else
          p.send_data "\n#{@initiator.name} flies up in the air."
        end
      end

      if @initiator.flying
        @initiator.flying = false
        @initiator.send_data "\nYou float to the ground."
      else
        @initiator.flying = true
        @initiator.send_data "\nYou fly high up into the air."
      end
    end
  end
end
