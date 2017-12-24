# frozen_string_literal: true

module Commands
  RSpec.describe Chat, type: [:command] do
    let(:subject) { described_class }

    describe "instance_methods" do
      before { @game = Game.instance }
      after  { @game.clear_connection_pool }

      describe "call" do
        it "sends a message to all the players in the game" do
          @game.run do |s|
            @initiator = SocketHelper.create_connection
            SocketHelper.populate_connection_pool

            @game.players.each do |p|
              expect(p).to receive(:send_data).with(
                "#{@initiator.player.name} chats: foo bar baz"
              )
            end

            subject.new(@initiator.player).call(%w[foo bar baz])

            s.stop_event_loop
          end
        end
      end
    end
  end
end
