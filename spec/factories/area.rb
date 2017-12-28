# frozen_string_literal: true

FactoryBot.define do
  factory :area, class: Area do
    name { "#{RandomWord.nouns.next.capitalize}" }
    rooms { [] }
    dimension { 15 }

    before(:create) { create(:sector) } # Make sure we have a sector available
  end
end

