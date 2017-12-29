# frozen_string_literal: true
require_relative "../commands/look"

class LoginProcess
  attr_accessor :new_character
  attr_reader   :connection,
                :player,
                :game,
                :creation_process

  def initialize(connection)
    @game = Game.instance
    @connection = connection
    post_init
  end

  def post_init
    @connection.send_data "Username?\n"
  end

  def call(data)
    @player ? verify_password(data) : verify_username(data)
  end

  private

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
    if @player.password == password
      @connection.process_player(@player)
      Commands::Look.new(@player).call
    else
      @connection.send_data "Incorrect password. Please try again.\n"
    end
  end
end
