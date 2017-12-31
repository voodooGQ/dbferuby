# frozen_string_literal: true

module Commands
  RSpec.describe East, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        it "moves the character to the correct room" do
          spec_socket_server { expect_movement(subject, 1, 0) }
        end

        it "warns the player when they can't go in that direction" do
          spec_socket_server do
            player = build(:player_connection).player

            allow(Movement).to receive(:linear).and_return(nil)
            expect(player).to receive(:send_data).and_return(
              "You can't go that way!\n"
            )
            subject.new(player).call
          end
        end

        it "sends proper messages to the roommates of the player" do
          spec_socket_server do
            expect_movement_messages(
              subject, exit_dir: "East", enter_dir: "West"
            )
          end
        end

        it "moves spherically" do
          spec_socket_server do
            movement_setup

            @player.room = Room.where(
              "x_coord = ? AND y_coord = ?", @coord_range.max, 0
            ).first

            expect(@player.room.x_coord).to be(@coord_range.max)
            expect(@player.room.y_coord).to be(0)
            subject.new(@player).call
            expect(@player.room.x_coord).to be(@coord_range.min)
            expect(@player.room.y_coord).to be(0)
          end
        end
      end

      describe "help" do
        it "returns a help string" do
          expect(subject.new(create(:player)).help).to be_a(String)
        end
      end
    end
  end
end
