# frozen_string_literal: true

Sector.create!(
  name: Array.new(rand(1..3), RandomWord.nouns.next).join("_"),
  character_code: "z",
  symbol: ".",
  color: "red",
  alternate_symbol: "@",
  alternate_color: "blue"
)

Area.create!(name: RandomWord.nouns.next.capitalize, dimension: 15)
