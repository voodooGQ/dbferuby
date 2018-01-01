# frozen_string_literal: true

class World < Hash
  def areas
    self[:areas] ||= {}
  end

  def rooms
    self[:rooms] ||= {}
  end
end
