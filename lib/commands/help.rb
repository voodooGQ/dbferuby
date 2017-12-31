# frozen_string_literal: true
require_relative "command_base"

module Commands
  class Help < CommandBase

    # List of Command classes to ignore
    HELP_LIST_IGNORE = [:CommandBase, :MovementBase]

    def call(args)
      keyword = args.first

      return @initiator.send_data(command_list) unless keyword
      return @initiator.send_data(help) if keyword == "help"

      begin
        klass = Object.const_get("Commands::#{keyword.capitalize}")
        obj = klass.new(@player)
      rescue NameError
        return command_not_found(keyword)
      end

      # Make sure they're able to access the command
      return command_not_found(keyword) unless obj.initiator_is_authorized?
      return @initiator.send_data(obj.help) if obj.respond_to?(:help)
      @initiator.send_data("#{keyword} does not currently have a help entry.")
    end

    def command_list(column_count: 6)
      terminal_width = `tput cols`.to_i
      col_width = terminal_width / column_count

      available_commands_for_initiator.compact
        .sort!
        .each_slice(column_count)
        .to_a
        .flat_map { |com| com.map{|c| c.ljust(col_width)} << "\n" }
        .join
    end

    def help
      <<~HELP
        #{"Syntax".red}: help
        #{"Syntax".red}: help <#{"keyword".cyan}>

        "help" without any arguments shows a one-page command summary.

        "help" <#{"keyword".cyan}> shows a page of help on that keyword.  The
        keywords include all the commands, spells, and skills listed in the
        game.
      HELP
    end

    private

    def command_not_found(command)
      @initiator.send_data(
        "#{command} is not a valid command. No help topic available."
      )
    end

    def available_commands_for_initiator
      Commands.constants.map do |command|
        next if HELP_LIST_IGNORE.include? command
        const = Commands.const_get(command)
        next unless const.is_a? Class
        next unless const.new(@initiator).initiator_is_authorized?
        command.to_s.downcase
      end.compact
    end
  end
end
