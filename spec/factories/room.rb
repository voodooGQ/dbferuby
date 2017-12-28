# frozen_string_literal: true

FactoryBot.define do
  factory :room, class: Room do
    sector { Sector.first || association(:sector) }
    area { Area.first || association(:area) }
    x_coord { area.rooms.flat_map(&:x_coord).max + 1 }
    y_coord { area.rooms.flat_map(&:y_coord).min - 1 }
  end
end
