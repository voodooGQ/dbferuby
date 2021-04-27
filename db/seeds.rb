# frozen_string_literal: true
require_relative "../lib/autoloader"
require 'random_word'

puts 'Creating Sector';

Sector.create!(
  name: Array.new(rand(1..3), RandomWord.nouns.next).join("_"),
  character_code: "z",
  symbol: ".",
  color: "red",
  alternate_symbol: "@",
  alternate_color: "blue"
)

puts 'Creating Area';

Area.create!(name: 'Earth', dimension: 15)

puts 'Done'
