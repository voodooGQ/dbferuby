# frozen_string_literal: true

module Commands
  class CommandBase
    attr_reader :initiator

    def initialize(initiator)
      @initiator = initiator
    end
  end
end
