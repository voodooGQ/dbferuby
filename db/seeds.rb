# frozen_string_literal: true
require_relative "../lib/autoloader"
require 'random_word'

puts 'Creating Sector';

if Sector.all.empty?
  Sector.create!(
    name: Array.new(rand(1..3), RandomWord.nouns.next).join("_"),
    character_code: "z",
    symbol: ".",
    color: "red",
    alternate_symbol: "@",
    alternate_color: "blue"
  )
end

puts 'Creating Area';

if Area.all.empty?
  Area.create!(name: 'Earth', dimension: 15)
end

puts 'Creating NPCs';

if NPC.all.empty?
  NPC.create!(
    name: 'Raditz',
    race: 'saiyan',
    room_id: 1,
    starting_area_id: 1,
    starting_room_id: 1
  )
end

puts 'Done'
