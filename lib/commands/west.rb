# frozen_string_literal: true
require_relative "command_base"

module Commands
  class West < CommandBase
    def call(*args)
      Movement.call(@initiator, x: -1)
      Look.new(@initiator).call
    end
  end
end
