# frozen_string_literal: true

class CommandParser
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def call(data)
    begin
      command, *args = data.chomp.split(" ")
      klass = Object.const_get("Commands::#{command.capitalize}")
      klass.new(@player).call(args)
    rescue NameError
      command ? command_not_found(command) : no_input
    end
    @player.send_data "\n>> "
  end

  def no_input
    @player.send_data "Please supply a command."
  end

  def command_not_found(command)
    @player.send_data "Huh?! #{command} is not a valid command."
  end
end
