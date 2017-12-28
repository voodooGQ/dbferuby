# frozen_string_literal: true
require "random-word"

FactoryBot.define do
  factory :sector, class: Sector do
    sequence(:name) do |n|
      Array.new(rand(1..3), RandomWord.nouns.next).join("_")
    end
    sequence(:character_code) { |n| (n + 33).chr }
    symbol { "~" }
    color { "blue" }
    alternate_symbol { "-" }
    alternate_color { "light_blue" }
  end
end
