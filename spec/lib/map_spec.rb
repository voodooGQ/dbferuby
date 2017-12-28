# frozen_string_literal: true
require "spec_helper"

RSpec.describe Map, type: [:model, :map] do
  let(:subject) { described_class }

  before do
    @area = create(:area)
    @map = Map.new(@area)
  end

  describe "instance_methods" do
    describe "show" do
      it "returns a string" do
        expect(@map.show(@area.rooms.first)).to be_a(String)
      end

      it "has the correct number of lines" do
        lines = @map.show(@area.rooms.first, 15, 25).split("\n")
        expect(lines.count).to eq(15)
      end

      it "outputs the proper sector items" do
        lines = @map.show(@area.rooms.first, 15, 25).split("\n")
        sector = Sector.first
        expect(lines.first).to eq(
          (sector.symbol.colorize(sector.color) * 25)
        )
      end
    end
  end
end
