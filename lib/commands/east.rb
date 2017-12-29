# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class East < MovementBase
    def call(*args)
      process_move(x: 1, exit_dir: "East", enter_dir: "West")
    end
  end
end
