# frozen_string_literal: true

RSpec.describe CreationProcess, type: [:process] do
  include_context "socket"
  let(:subject) { described_class }

  describe "instance_methods" do
    describe "call" do
      it "calls to the welcome method" do
        spec_socket_server do
          connection = build(:player_connection)
          obj = subject.new(connection)
          expect(obj).to receive(:welcome)
          obj.call("new")
        end
      end

      it "calls to the set_name method" do
        spec_socket_server do
          connection = build(:player_connection)
          obj = subject.new(connection)
          expect(obj).to receive(:set_name).with("foo")
          obj.call("foo")
        end
      end

      it "calls to the set_password method" do
        spec_socket_server do
          connection = build(:player_connection)
          obj = subject.new(connection).tap do |o|
            o.instance_variable_set(:@name, "foo")
          end
          expect(obj).to receive(:set_password).with("bar")
          obj.call("bar")
        end
      end

      it "calls to the set_password_confirm method" do
        spec_socket_server do
          connection = build(:player_connection)
          obj = subject.new(connection).tap do |o|
            o.instance_variable_set(:@name, "foo")
            o.instance_variable_set(:@password, "bar")
          end
          expect(obj).to receive(:set_password_confirm).with("bar")
          obj.call("bar")
        end
      end

      it "calls to the set_race method" do
        spec_socket_server do
          connection = build(:player_connection)
          race = Player::VALID_RACES.first
          obj = subject.new(connection).tap do |o|
            o.instance_variable_set(:@name, "foo")
            o.instance_variable_set(:@password, "bar")
            o.instance_variable_set(:@password_confirm, "bar")
          end
          expect(obj).to receive(:set_race).with(race)
          obj.call(race)
        end
      end
    end
  end
end
