# frozen_string_literal: true
require "active_record"

class Player < ActiveRecord::Base
  attr_accessor :connection

  VALID_RACES = %w[saiyan human namek icer mutant android]

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :race, presence: true, inclusion: {
    in: VALID_RACES, message: "%{value} is not a valid race"
  }

  establish_connection(adapter: "sqlite3", database: "dbfe.db")
  connection.create_table(:players, force: true) do |t|
    t.string :name
    t.string :password
    t.string :race
    t.timestamps
  end unless table_exists?

  def method_missing(m, *args, &block)
    @connection.send(m, *args, &block)
  end

  def respond_to_missing?(m, include_private = false)
    @connection.respond_to?(m, include_private) || super
  end
end
