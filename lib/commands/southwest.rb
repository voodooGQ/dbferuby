# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class Southwest < MovementBase
    def call(*args)
      process_move(y: 1, x: -1, exit_dir: "Southwest", enter_dir: "Northeast")
    end
  end
end
