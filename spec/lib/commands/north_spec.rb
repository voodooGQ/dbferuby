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
