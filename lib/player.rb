# frozen_string_literal: true

class Player
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def method_missing(m, *args, &block)
    @connection.send(m, *args, &block)
  end

  def respond_to_missing?(m, include_private = false)
    @connection.respond_to?(m, include_private) || super
  end
end
