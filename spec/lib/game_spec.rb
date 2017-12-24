# frozen_string_literal: true

RSpec.describe Game, type: [:main, :server] do
  include_context "socket"
  let(:subject) { described_class }

  describe "instance_methods" do
    before { @instance = subject.instance }
    after  { @instance.clear_connection_pool }

    describe "add_connection_to_pool" do
      it "calls to the connections 'add_connection' method" do
        @instance.run do |server|
          expect(@instance.connections).to receive(:add_connection)
          @instance.add_connection_to_pool(EventMachine::Connection.new(1))
          server.stop_event_loop
        end
      end
    end

    describe "remove_connection_from_pool" do
      it "calls to the connections 'remove_connection' method" do
        @instance.run do |server|
          expect(@instance.connections).to receive(:remove_connection)
          @instance.remove_connection_from_pool(EventMachine::Connection.new(1))
          server.stop_event_loop
        end
      end
    end

    describe "clear_connection_pool" do
      it "calls to the connections 'clear' method" do
        @instance.run do |server|
          expect(@instance.connections).to receive(:clear).at_least(:twice)
          @instance.clear_connection_pool
          server.stop_event_loop
        end
      end
    end

    describe "connection_count" do
      it "calls to the connections 'count' method" do
        @instance.run do |server|
          expect(@instance.connections).to receive(:count)
          @instance.connection_count
          server.stop_event_loop
        end
      end
    end

    describe "players" do
      it "calls to the connections 'player' method" do
        @instance.run do |server|
          expect(@instance.connections).to receive(:players)
          @instance.players
          server.stop_event_loop
        end
      end
    end
  end
end
