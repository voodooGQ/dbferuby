# frozen_string_literal: true
require_relative "movement_base"

module Commands
  class South < MovementBase
    def call(*args)
      process_move(y: 1, exit_dir: "South", enter_dir: "North")
    end
  end
end
