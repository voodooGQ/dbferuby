# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class North < MovementBase
    def call(*args)
      process_move(y: -1, exit_dir: "North", enter_dir: "South")
    end
  end
end
