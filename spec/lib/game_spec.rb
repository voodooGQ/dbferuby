# frozen_string_literal: true

RSpec.describe Game, type: [:main, :server] do
  include_context "socket"
  let(:subject) { described_class }

  describe "instance_methods" do
    before { @instance = subject.instance }

    describe "add_connection_to_pool" do
      it "calls to the connections 'add_connection' method" do
        spec_socket_server do |server|
          expect(@instance.connections).to receive(:add_connection)
          @instance.add_connection_to_pool(EventMachine::Connection.new(1))
        end
      end
    end

    describe "remove_connection_from_pool" do
      it "calls to the connections 'remove_connection' method" do
        spec_socket_server do |server|
          expect(@instance.connections).to receive(:remove_connection)
          @instance.remove_connection_from_pool(EventMachine::Connection.new(1))
        end
      end
    end

    describe "clear_connection_pool" do
      it "calls to the connections 'clear' method" do
        spec_socket_server do |server|
          expect(@instance.connections).to receive(:clear).at_least(:twice)
          @instance.clear_connection_pool
        end
      end
    end

    describe "connection_count" do
      it "calls to the connections 'count' method" do
        spec_socket_server do |server|
          expect(@instance.connections).to receive(:count)
          @instance.connection_count
        end
      end
    end

    describe "players" do
      it "calls to the connections 'player' method" do
        spec_socket_server do |server|
          expect(@instance.connections).to receive(:players)
          @instance.players
        end
      end
    end
  end
end
