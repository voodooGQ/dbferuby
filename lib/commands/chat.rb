# frozen_string_literal: true

module Commands
  class Chat < CommandBase
    def call(args)
      game = Game.instance
      game.players.each do |player|
        player.send_data "Chat: #{args.join(" ")}"
      end
    end
  end
end
