# frozen_string_literal: true
require "random-word"

FactoryBot.define do
  factory :sector, class: Sector do
    sequence(:name) {|n| Array.new(rand(1..3), RandomWord.noun.next).join("_") }
    sequence(:character_code) { |n| (n + 33).char }
    symbol { "~" }
    color { "blue" }
    alternate_symbol { "-" }
    alternate_color { "light_blue" }
  end
end
