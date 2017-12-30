# frozen_string_literal: true

module Commands
  RSpec.describe West, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        it "moves the character to the correct room" do
          spec_socket_server { expect_movement(subject, -1, 0) }
        end

        it "moves spherically" do
          spec_socket_server do
            movement_setup

            @player.room = Room.where(
              "x_coord = ? AND y_coord = ?", @coord_range.min, 0
            ).first

            expect(@player.room.x_coord).to be(@coord_range.min)
            expect(@player.room.y_coord).to be(0)
            subject.new(@player).call
            expect(@player.room.x_coord).to be(@coord_range.max)
            expect(@player.room.y_coord).to be(0)
          end
        end
      end
    end
  end
end
