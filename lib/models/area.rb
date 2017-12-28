# frozen_string_literal: true
#
# == Schema Information
#
# Table name: areas
#
#  id        :integer          not null, primary key
#  name      :string
#  dimension :integer          default(15), not null
#

require "active_record"

class Area < ActiveRecord::Base
  has_many :rooms
  validates :dimension, presence: true, numericality: {
    odd: true, greater_than_or_equal_to: 15, less_than_or_equal_to: 101
  }
end
