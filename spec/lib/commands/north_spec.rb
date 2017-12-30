# frozen_string_literal: true

module Commands
  RSpec.describe North, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        it "moves the character to the correct room" do
          spec_socket_server { expect_movement(subject, 0, -1) }
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
              subject, exit_dir: "North", enter_dir: "South"
            )
          end
        end

        it "moves spherically" do
          spec_socket_server do
            movement_setup

            @player.room = Room.where(
              "x_coord = ? AND y_coord = ?", 0, @coord_range.min,
            ).first

            expect(@player.room.x_coord).to be(0)
            expect(@player.room.y_coord).to be(@coord_range.min)
            subject.new(@player).call
            expect(@player.room.x_coord).to be(0)
            expect(@player.room.y_coord).to be(@coord_range.max)
          end
        end
      end
    end
  end
end
