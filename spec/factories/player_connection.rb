# frozen_string_literal: true

FactoryBot.define do
  factory :player_connection, class: PlayerConnection do
    sequence :sig { |s| s }
    player { create(:player) }

    initialize_with{ new(sig) }

    before(:build) do
      unless EventMachine::Connection.included_modules
        .include?(PlayerConnection)
        class EventMachine::Connection
          include PlayerConnection
        end
      end
    end

    after(:build) { |conn| conn.process_player(conn.player) }
  end
end
