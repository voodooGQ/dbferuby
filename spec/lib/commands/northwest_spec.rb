# frozen_string_literal: true

module Commands
  RSpec.describe Northwest, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        it "moves the character to the correct room" do
          spec_socket_server do
            room = Room.where("x_coord = ? AND y_coord = ?", 0, 0).first ||
              create(:room, y_coord: 0, x_coord: 0)
            connection = build(:player_connection)

            player = connection.player
            player.room = room

            expect(player.room.x_coord).to be(0)
            expect(player.room.y_coord).to be(0)

            subject.new(player).call

            expect(player.room.x_coord).to be(-1)
            expect(player.room.y_coord).to be(-1)
          end
        end
      end
    end
  end
end
