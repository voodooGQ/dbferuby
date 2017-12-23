# frozen_string_literal: true

class LoginProcess
  attr_reader :connection, :player, :game

  def initialize(connection)
    @game = Game.instance
    @connection = connection
    @connection.send_data "Username?\n"
  end

  def call(data)
    if !@player && data == "new"
      # Creation Process
    end

    if !@player
      verify_username(data.chomp)
    else
      verify_password(data.chomp)
    end
  end

  def verify_username(username)
    if @player = Player.where(name: username).first
      @connection.send_data "Password?\n"
    else
      @connection.send_data(
        "No user named #{username} exists. Please try again.\n"
      )
    end
  end

  # @todo: Stiffen up security here
  def verify_password(password)
    if @player
      if @player.password == password
        @connection.process_player(@player)
      else
        @connection.send_data "Incorrect password. Please try again.\n"
      end
    end
  end
end
