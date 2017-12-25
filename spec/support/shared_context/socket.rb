# frozen_string_literal: true

RSpec.shared_context "socket", shared_context: :meta_data do
  # Sanitize a mock game loop
  def spec_socket_server(debug: false, &block)
    game = Game.instance

    SpecHelperFunctions.suppress_output(override: debug) do
      game.run do |s|
        yield(s)
        s.stop_event_loop
      end
    end
    game.clear_connection_pool
  end

  def populate_connection_pool(number_of_connections: 5)
    FactoryBot.build_list(:player_connection, number_of_connections).each do |c|
      c.process_player(FactoryBot.create(:player))
    end
  end

  def create_connection(player: FactoryBot.create(:player))
    FactoryBot.build(:player_connection).tap do |c|
      c.process_player(player)
    end
  end

  def stub_connection_unbind(connection)
    allow(connection.player).to(
      receive(:close_connection).and_wrap_original do |m, *args|
        connection.unbind
      end
    )
  end
end
