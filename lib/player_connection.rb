# frozen_string_literal: true

require_relative 'player'
require_relative 'game'
require_relative 'command_parser'

module PlayerConnection
  attr_accessor :player, :new_character
  attr_reader :game, :command_parser, :login_processor, :creation_processor

  def initialize
    @game = Game.instance
    @login_processor = LoginProcess.new(self)
    @creation_processor = CreationProcess.new(self)
    @new_character = false
  end

  def post_init
    puts "-- someone connected to the echo server!"
  end

  def process_player(player)
    @player = player
    @player.connection = self
    @command_parser = CommandParser.new(@player)
    add_player_to_connection_pool
  end

  def add_player_to_connection_pool
    @game.players << @player if @player
  end

  def receive_data(data)
    data = data.chomp
    if @new_character || (!@player && data == "new")
      @creation_processor.call(data)
    elsif !@player
      @login_processor.call(data)
    else
      @command_parser.call(data)
    end
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
    @game.players.delete_if {|p| p.connection == self}
  end
end
