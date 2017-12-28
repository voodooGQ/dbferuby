# frozen_string_literal: true

FactoryBot.define do
  factory :area, class: Area do
    name { "#{RandomWord.nouns.next.capitalize}" }
    rooms { [] }
    after(:create) do |area|
      ((rand(10..20) * 2) + 1).times do |index|
        area.rooms << create(:room, x_coord: 0 + index, y_coord: 0 - index, area: area)
      end
    end
  end
end

