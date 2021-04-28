# frozen_string_literal: true
#
# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  name       :string
#  password   :string
#  race       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "active_record"

class Player < Character
  attr_accessor :connection

  [:admin?, :is_admin?].each{ |m| alias_attribute m, :admin }

  def connected?
    !!@connection
  end

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
