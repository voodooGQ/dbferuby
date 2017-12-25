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
      # veify_username
      describe "when player is not set" do
        it "calls locally to verify_username with the data sent" do
          spec_socket_server do
            obj = subject.new(build(:player_connection))
            expect(obj).to receive(:verify_username).with("foo")
            obj.call("foo")
          end
        end

        describe "when Player is found by username" do
          it "sets the player variable" do
            spec_socket_server do
              player = create(:player)
              obj = subject.new(build(:player_connection))
              obj.call(player.name)
              expect(obj.player).to eq(player)
            end
          end

          it "sends a password prompt to the connection" do
            spec_socket_server do
              player = create(:player)
              obj = subject.new(build(:player_connection))

              expect(obj.connection).to receive(:send_data).with("Password?\n")
              obj.call(player.name)
            end
          end
        end

        describe "when Player is not found by username" do
          it "sends a propmpt to the player to try again" do
            spec_socket_server do
              obj = subject.new(build(:player_connection))

              expect(obj.connection).to receive(:send_data).with(
                "No user named foobarbaz exists. Please try again.\n"
              )
              obj.call("foobarbaz")
            end
          end
        end
      end

      # verify_password
      describe "when player is set" do
        it "calls locally to verify_password with the data sent" do
          spec_socket_server do
            obj = subject.new(build(:player_connection))
            obj.instance_variable_set(:@player, obj.connection.player)

            expect(obj).to receive(:verify_password).with("foo")
            obj.call("foo")
          end
        end

        describe "when the password sent matches the player password" do
          it "calls process_player on the connection with the player sent" do
            spec_socket_server do
              obj = subject.new(build(:player_connection))
              obj.instance_variable_set(:@player, obj.connection.player)
              expect(obj.connection).to receive(:process_player).with(
                obj.connection.player
              )
              obj.call("abcd1234")
            end
          end
        end

        describe "when the password send does not match the player password" do
          it "sends an incorrect password prompt to the player" do
            spec_socket_server do
              obj = subject.new(build(:player_connection))
              obj.instance_variable_set(:@player, obj.connection.player)
              expect(obj.connection).to receive(:send_data).with(
                "Incorrect password. Please try again.\n"
              )
              obj.call("4321dcba")
            end
          end
        end
      end
    end
  end
end
