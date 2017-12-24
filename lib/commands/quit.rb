# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Quit < CommandBase
    def call(*args)
      @initiator.close_connection if @initiator.respond_to?(:close_connection)
    end
  end
end
