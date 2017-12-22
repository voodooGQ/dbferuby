# frozen_string_literal: true
require 'singleton'

class ConnectionPool < Array
  include Singleton
end

