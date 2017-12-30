# frozen_string_literal: true
require "spec_helper"

RSpec.describe Player, type: [:model] do
  include_context "socket"
  let(:subject) { described_class }

  describe "instance_methods" do
    describe "method_missing" do
      it "passes unknown methods to the connection" do
        player = build(:player)
        player.instance_variable_set(
          :@connection, instance_double("PlayerConneciton")
        )

        expect(player.connection).to receive(:foo)
        player.foo
      end
    end

    describe "connected?" do
      it "returns true if a connetion is present" do
        player = build(:player)
        player.instance_variable_set(
          :@connection, instance_double("PlayerConnection")
        )
        expect(player.connected?).to be_truthy
      end

      it "returns false if connection is not present" do
        expect(build(:player).connected?).to be_falsey
      end
    end

    describe "roommates" do
      it "returns the players in the same room as the player" do
        spec_socket_server do
          movement_setup
          player2 = build(:player_connection).player
          player3 = build(:player_connection).player

          send_player_to_area_center(@player)
          send_player_to_area_center(player2)
          player3.room = Room.where(
            "x_coord = ? AND y_coord = ?", 1, 1
          ).first
          player3.save!

          expect(@player.roommates.count).to eq(1)
          expect(@player.roommates.include?(player2)).to be_truthy
        end
      end
    end

    describe "areamates" do
      it "returns the players in the same area as the player" do
        spec_socket_server do
          movement_setup
          player2 = build(:player_connection).player
          player3 = build(:player_connection).player
          area2 = create(:area)

          send_player_to_area_center(@player)
          send_player_to_area_center(player2)
          player3.room = area2.rooms.first
          player3.save!

          expect(@player.areamates.count).to eq(1)
          expect(@player.areamates.include?(player2)).to be_truthy
        end
      end
    end
  end

  describe "class_methods" do
    describe "race_list" do
      it { expect(subject.race_list).to eq(subject::VALID_RACES.join(", ")) }
    end
  end
end
