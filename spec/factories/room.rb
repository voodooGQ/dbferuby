# frozen_string_literal: true

FactoryBot.define do
  factory :room, class: Room do
    x_coord { 0 }
    y_coord { 0 }
    sector { create(:sector) }
  end
end
