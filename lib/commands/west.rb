 # frozen_string_literal: true
require_relative "movement_base"

module Commands
  class West < MovementBase
    def call(*args)
      process_move(x: -1, exit_dir: "West", enter_dir: "East")
    end
  end
end
