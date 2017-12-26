# frozen_string_literal: true

FactoryBot.define do
  factory :sector, class: Sector do
    name { "blue_water" }
    character_code { "a" }
    symbol { "~" }
    color { "blue" }
    alternate_symbol { "-" }
    alternate_color { "light_blue" }
  end
end
