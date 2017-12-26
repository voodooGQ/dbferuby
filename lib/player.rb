# frozen_string_literal: true
require "active_record"

class Player < ActiveRecord::Base
  attr_accessor :connection

  VALID_RACES = %w[saiyan human namek icer mutant android]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :race, presence: true, inclusion: {
    in: VALID_RACES, message: "%{value} is not a valid race"
  }

  def method_missing(m, *args, &block)
    @connection.send(m, *args, &block)
  end

  def respond_to_missing?(m, include_private = false)
    @connection.respond_to?(m, include_private) || super
  end

  def self.race_list
    VALID_RACES.join(", ")
  end
end
