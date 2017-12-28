# frozen_string_literal: true
require_relative "command_base"

module Commands
  class South < CommandBase
    def call(*args)
      Movement.call(@initiator, y: 1)
      Look.new(@initiator).call
    end
  end
end
