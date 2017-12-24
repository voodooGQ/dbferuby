# frozen_string_literal: true

RSpec.describe ConnectionPool, type: [:wrapper] do
  include_context "socket"
  let(:subject) { described_class }

  before { @obj = subject.new }

  describe "instance_methods" do
    describe "add_connection" do
      it "raises an error when added item is not an EM::Connection" do
        expect(@obj.count).to be(0)
        expect{ @obj.add_connection("foo") }.to raise_error(
          StandardError
        ).with_message(
          "Must be of type EventMachine::Connection to add to the " \
          "connection pool"
        )
        expect(@obj.count).to be (0)
      end

      it "adds a new connection to the pool" do
        expect{ @obj.add_connection(EventMachine::Connection.new(1)) }.to(
          change{ @obj.count }.by(1)
        )
      end
    end

    describe "remove_connection" do
      before do
        @con1 = EventMachine::Connection.new(1)
        @con2 = EventMachine::Connection.new(2)
        @con3 = EventMachine::Connection.new(3)
        @obj << @con1 << @con2
      end

      it "removes from the pool if the passed connection is found" do
        expect(@obj.count).to be(2)
        @obj.remove_connection(@con1)
        expect(@obj.count).to be(1)
      end

      it "leaves the pool in tact if the connection is not found" do
        expect(@obj.count).to be(2)
        @obj.remove_connection(@con3)
        expect(@obj.count).to be(2)
      end
    end

    describe "players" do
      before do
        @con1 = EventMachine::Connection.new(1)
        @player1 = build(:player)
        allow(@con1).to receive(:player).and_return(@player1)
        @obj.add_connection(@con1)

        @con2 = EventMachine::Connection.new(2)
        @player2 = build(:player)
        allow(@con2).to receive(:player).and_return(@player2)
        @obj.add_connection(@con2)
      end

      it "returns the list of players associated with connections" do
        expect(@obj.players).to eq([@player1, @player2])
      end
    end
  end
end
