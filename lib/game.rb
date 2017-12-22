# frozen_string_literal: true

require 'eventmachine'
require 'singleton'
require_relative 'connection_pool'
require_relative 'player_connection'

class Game
  include Singleton

  attr_reader :server,
              :players

  def initialize
    @players = ConnectionPool.instance
  end

  def run(ip: "127.0.0.1", port: "8081", socket_server: EventMachine)
    @server ||= socket_server.run do
      socket_server.start_server ip, port, PlayerConnection
    end
  end
end

