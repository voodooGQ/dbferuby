# frozen_string_literal: true

class SocketHelper
  def self.populate_connection_pool(number_of_connections: 5)
    FactoryBot.build_list(:player_connection, number_of_connections).each do |c|
      c.process_player(FactoryBot.create(:player))
    end
  end

  def self.create_connection(player: FactoryBot.create(:player))
    FactoryBot.build(:player_connection).tap do |c|
      c.process_player(player)
    end
  end
end
