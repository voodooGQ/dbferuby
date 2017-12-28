# frozen_string_literal: true
require "spec_helper"

RSpec.describe Area, type: [:models] do
  let(:subject) { described_class }

  describe "instance_methods" do
    before { @area = create(:area) }

    describe "coord_index_range" do
      it "returns the proper zero_offset range for the area dimension" do
        expect(@area.coord_index_range).to eq((-7..7))
        area2 = create(:area, dimension: 17)
        expect(area2.coord_index_range).to eq((-8..8))
      end
    end

    describe "center_room" do
      it "returns the proper room object" do
        room = @area.center_room
        expect(room.x_coord).to eq(0)
        expect(room.y_coord).to eq(0)
      end
    end

    describe "room_by_coords" do
      it "returns the proper room object" do
        room = @area.room_by_coords(1, 1)
        expect(room.x_coord).to eq(1)
        expect(room.y_coord).to eq(1)
      end
    end

    describe "map" do
      it "returns a new map object" do
        expect(@area.map).to be_a(Map)
      end
    end
  end
end
