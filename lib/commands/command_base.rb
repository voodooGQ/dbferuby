# frozen_string_literal: true

module Commands
  class CommandBase
    attr_reader :initiator

    def initialize(initiator)
      @initiator = initiator
    end

    # Override policy on individual commands to ensure initiator
    # can utilize command.
    def policy
      true
    end

    # inheritable alias for policy
    def initiator_is_authorized?
      policy
    end
  end
end
