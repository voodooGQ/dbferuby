# frozen_string_literal: true
require "active_record"

class Area < ActiveRecord::Base
  has_many :rooms
end
