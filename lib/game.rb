# frozen_string_literal: true

require 'eventmachine'
require 'singleton'
require_relative 'connection_pool'
require_relative 'player_connection'

class Game
  include Singleton

  attr_reader :server,
              :connections

  def initialize
    @connections = ConnectionPool.new
  end

  def add_connection_to_pool(connection)
    unless connection.kind_of?(EventMachine::Connection)
      raise StandardError, "Must be of type EventMachine::Connection to add " \
        "to the connection pool"
    end

    @connections << connection
  end

  def remove_connection_from_pool(connection)
    @connections.delete_if{ |c| c == connection }
  end

  def clear_connection_pool
    @connections.clear
  end

  def connection_count
    @connections.count
  end

  def players
    @connections.map(&:player)
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

