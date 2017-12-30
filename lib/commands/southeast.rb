# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class Southeast < MovementBase
    def call(*args)
      process_move(y: 1, x: 1, exit_dir: "Southeast", enter_dir: "Northwest")
    end
  end
end
