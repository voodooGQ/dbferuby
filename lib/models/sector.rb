# frozen_string_literal: true
require "active_record"
require "colorize"

class Sector < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :character_code,
            presence: true,
            uniqueness: { case_sensitive: true },
            length: { maximum: 1 }

  def color
    (self[:color] ||= "default").to_sym
  end

  def alternate_color
    self[:alternate_color].to_sym if self[:alternate_color]
  end

  def to_s
    symbol.colorize(color)
  end

  def alternate_to_s
    (alternate_symbol || symbol).colorize(alternate_color || color)
  end
end
