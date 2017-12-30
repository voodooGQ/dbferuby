# frozen_string_literal: true
require "spec_helper"

RSpec.describe Movement, type: [:service] do
  include_context "socket"
  let(:subject) { described_class }

  describe "class_methods" do
    describe "linear" do
      it "returns the room object" do
        spec_socket_server(debug: true) do
          player = create(:player)
          send_player_to_area_center(player)
          expect(subject.linear(player, x: 1, y: 1)).to eq(
            player.area.rooms.where(
              "x_coord = ? AND y_coord = ?",
              player.room.x_coord + 1,
              player.room.y_coord + 1
            ).first
          )
        end
      end
    end
  end
end
