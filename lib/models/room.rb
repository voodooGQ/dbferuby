# frozen_string_literal: true
require "active_record"

class Room < ActiveRecord::Base
  belongs_to :area
  belongs_to :sector
end
