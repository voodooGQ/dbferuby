# frozen_string_literal: true

module Commands
  RSpec.describe Chat, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      before { @game = Game.instance }
      after  { @game.clear_connection_pool }

      describe "call" do
        it "sends a message to all the players in the game" do
          spec_socket_server do |server|
            @initiator = build(:player_connection)
            populate_connection_pool

            @game.players.each do |p|
              expect(p).to receive(:send_data).with(
                "#{@initiator.player.name} chats: foo bar baz"
              )
            end

            subject.new(@initiator.player).call(%w[foo bar baz])
          end
        end
      end
    end
  end
end
