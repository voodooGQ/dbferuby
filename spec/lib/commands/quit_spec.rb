# frozen_string_literal: true

module Commands
  RSpec.describe Quit, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      before { @game = Game.instance }
      after  { @game.clear_connection_pool }

      describe "call" do
        it "removes the initiator from the connection pool" do
          spec_socket_server do |server|
            initiator = create_connection
            expect(@game.connection_count).to eq(1)

            stub_connection_unbind(initiator)
            expect(initiator.player).to receive(:close_connection)

            expect{
              subject.new(initiator.player).call
            }.to change{ @game.connection_count }.by(-1)
          end
        end
      end
    end
  end
end
