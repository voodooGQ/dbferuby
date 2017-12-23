# frozen_string_literal: true

require_relative 'player'
require_relative 'game'
require_relative 'command_parser'

module PlayerConnection
  attr_reader :game, :player, :command_parser

  def initialize
    @game = Game.instance
  end

  def post_init
    puts "-- someone connected to the echo server!"

    @player = Player.create!(name: "bar")
    @player.connection = self
    @command_parser = CommandParser.new(@player)

    binding.pry

    @game.players << @player
    @player.send_data ">> "
  end

  def receive_data(data)
    @command_parser.call(data)
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
    @game.players.delete_if {|p| p.connection == self}
  end
end
