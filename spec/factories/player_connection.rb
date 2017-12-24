# frozen_string_literal: true

FactoryBot.define do
  factory :player_connection, class: PlayerConnection do
    sequence :sig { |s| s }

    initialize_with{ new(sig) }

    before(:build) do
      unless EventMachine::Connection.included_modules
        .include?(PlayerConnection)
        class EventMachine::Connection
          include PlayerConnection
        end
      end
    end

    #after(:build) do
      #process_player(create(:player))
    #end
  end
end
