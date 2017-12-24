# frozen_string_literal: true

RSpec.describe Game, type: [:main, :server] do
  include_context "socket"
  let(:subject) { described_class }

  describe "instance_methods" do
    before { @instance = subject.instance }
    after  { @instance.clear_connection_pool }

    describe "add_connection_to_pool" do
      it "raises an error when added item is not an EM::Connection" do
        @instance.run do |server|
          expect(@instance.connection_count).to eq(0)

          expect{ @instance.add_connection_to_pool("foo") }.to raise_error(
            StandardError
          ).with_message(
            "Must be of type EventMachine::Connection to add to the " \
            "connection pool"
          )

          expect(@instance.connection_count).to eq(0)

          server.stop_event_loop
        end
      end

      it "adds a new connection to the pool" do
        @instance.run do |server|
          expect(@instance.connection_count).to eq(0)

          expect{ create_connection }.to(
            change{ @instance.connection_count }.by(1)
          )

          server.stop_event_loop
        end
      end
    end
  end
end
