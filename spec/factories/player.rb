# frozen_string_literal: true
require "securerandom"

FactoryBot.define do
  factory :player, class: Player do
    sequence :name { |n| "Player_#{n}" }
    password { "abcd1234" }
    race do
      index = rand(0..(Player::VALID_RACES.length - 1))
      Player::VALID_RACES[index]
    end
    room { Room.first || association(:room) }
  end
end
