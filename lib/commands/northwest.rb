# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class Northwest < MovementBase
    def call(*args)
      process_move(y: -1, x: -1, exit_dir: "Northwest", enter_dir: "Southeast")
    end
  end
end
