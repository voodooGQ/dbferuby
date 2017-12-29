# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Northeast < CommandBase
    def call(*args)
      Movement.call(@initiator, y: -1, x: 1)
      Look.new(@initiator).call
    end
  end
end
