# frozen_string_literal: true
require "spec_helper"

RSpec.describe LoginProcess, type: :TYPE do
  include_context "socket"

  let(:subject) { described_class }

  describe "instance_methods" do
    describe "post_init" do
      it "sends an initial prompt" do
        spec_socket_server do
          obj = subject.new(build(:player_connection))
          expect(obj.connection).to receive(:send_data).with("Username?\n")
          obj.post_init
        end
      end
    end

    describe "call" do
      describe "when player is not set" do
        it "calls locally to verify_username with the data sent" do
          spec_socket_server do
            obj = subject.new(build(:player_connection))
            expect(obj).to receive(:verify_username).with("foo")
            obj.call("foo")
          end
        end
      end

      describe "when player is set" do
        it "calls locally to verify_password with the data sent" do
          spec_socket_server do
            obj = subject.new(build(:player_connection))
            obj.instance_variable_set(:@player, build(:player))

            expect(obj).to receive(:verify_password).with("foo")
            obj.call("foo")
          end
        end
      end
    end
  end
end
