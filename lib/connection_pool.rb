# frozen_string_literal: true

class ConnectionPool < Array
  def add_connection(connection)
    unless connection.kind_of?(EventMachine::Connection)
      raise StandardError, "Must be of type EventMachine::Connection to add " \
        "to the connection pool"
    end

    self << connection
  end

  def remove_connection(connection)
    self.delete_if{ |c| c == connection }
  end

  def players
    self.map(&:player)
  end
end

