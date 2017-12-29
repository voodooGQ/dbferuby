# frozen_string_literal: true

class CommandParser
  attr_reader :player

  GLOBAL_ALIASES = {
    'n'     => 'north',
    's'     => 'south',
    'e'     => 'east',
    'w'     => 'west',
    'ne'    => 'northeast',
    'nw'    => 'northwest',
    'se'    => 'southeast',
    'sw'    => 'southwest',
    'l'     => 'look',
    'exit'  => 'quit'
  }

  def initialize(player)
    @player = player
  end

  def call(data)
    begin
      command, *args = data.chomp.split(" ")
      # Check the global aliases
      command = GLOBAL_ALIASES.dig(command) || command
      klass = Object.const_get("Commands::#{command.capitalize}")
      klass.new(@player).call(args)
    rescue NameError
      command ? command_not_found(command) : no_input
    end
    @player.send_data "\n>> "
  end

  private

  def no_input
    @player.send_data "Please supply a command."
  end

  def command_not_found(command)
    @player.send_data "Huh?! #{command} is not a valid command."
  end
end
