# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Chat < CommandBase
    def call(*args)
      game = Game.instance
      game.players.each do |player|
        player.send_data "#{@initiator.name} chats: #{args.join(" ")}"
      end
    end
  end
end
