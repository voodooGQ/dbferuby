# frozen_string_literal: true

require 'eventmachine'
require 'singleton'
require 'forwardable'
require_relative 'connection_pool'
require_relative 'player_connection'
require_relative 'world'

class Game
  extend Forwardable
  include Singleton

  attr_reader :server,
              :connections,
              :world

  def initialize
    @connections = ConnectionPool.new
    @world ||= build_world
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

  def build_world
    World.new.tap do |world|
      Area.all.each do |area|
        world.areas[area.id] = {}
        world.areas[area.id]["area"] = area
        world.areas[area.id]["rooms"] = {}
      end
      Room.all.each do |room|
        world.rooms[room.id] = room
        world.areas[room.area_id]["rooms"][room.id] = room
      end
    end
  end

  def_delegator  :@connections, :add_connection,    :add_connection_to_pool
  def_delegator  :@connections, :remove_connection, :remove_connection_from_pool
  def_delegator  :@connections, :clear,             :clear_connection_pool
  def_delegator  :@connections, :count,             :connection_count
  def_delegators :@connections, :players
end

