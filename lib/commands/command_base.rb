# frozen_string_literal: true
require_relative 'command_base'

module Commands
  class CommandBase
    attr_reader :initiator

    def initialize(initiator)
      @initiator = initiator
    end
  end
end
