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
    @players = ConnectionPool.new
  end

  def clear_connection_pool
    @players.clear
  end

  def connection_count
    @players.count
  end

  def run(ip: "127.0.0.1", port: "8081", socket_server: EventMachine, &block)
    @server ||= socket_server.run do |s|
      # hit Control + C to stop
      Signal.trap("INT")  { socket_server.stop }
      Signal.trap("TERM") { socket_server.stop }

      socket_server.start_server ip, port, PlayerConnection
      yield(socket_server) if block_given?
    end
  end
end

