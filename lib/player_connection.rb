# frozen_string_literal: true

require_relative 'player'
require_relative 'game'

module PlayerConnection
  attr_reader :game, :player

  def initialize
    @game = Game.instance
  end

  def post_init
    puts "-- someone connected to the echo server!"
    @player = Player.new(self)
    @game.players << @player
  end

  def receive_data data
    @game.players.each {|c| c.send_data "chat: #{data}"} if data =~ /chat/i
    send_data ">>>you sent: #{data}"
    send_data @game.connections.count if data =~ /connections/i
    close_connection if data =~ /quit/i
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
    @game.players.delete_if {|p| p.connection == self}
  end
end

