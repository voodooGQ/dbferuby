# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class Northeast < MovementBase
    def call(*args)
      process_move(y: -1, x: 1, exit_dir: "Northeast", enter_dir: "Southwest")
    end
  end
end
