# frozen_string_literal: true

require_relative 'player'
require_relative 'game'
require_relative 'command_parser'

class PlayerConnection < EventMachine::Connection
  attr_accessor :player,
                :new_character

  attr_reader :game,
              :command_parser,
              :login_processor,
              :creation_processor,
              :intentionally_closed_connection

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
    @game.add_connection_to_pool(@player.connection)
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

  def close_connection(*args)
    @intentionally_closed_connection = true
    super(*args)
  end

  def unbind
    if @intentionally_closed_connection
    # @todo: Allow for resume on dropped connections
    end
    puts "-- someone disconnected from the echo server!"
    @game.remove_connection_from_pool(self)
  end
end
