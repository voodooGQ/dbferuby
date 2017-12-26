# frozen_string_literal: true
require "spec_helper"
require "colorize"

RSpec.describe Area, type: [:models] do
  let(:subject) { described_class }

  describe "instance_methods" do
    describe "color" do
      before { @sector = build(:sector) }

      it "converts the saved value to a symbol" do
        expect(@sector.color).to eq(:blue)
      end

      it "returns the default color when there is no color attached" do
        @sector.color = nil
        expect(@sector.color).to eq(:default)
      end
    end

    describe "to_s" do
      before { @sector = build(:sector) }

      it do
        expect(@sector.to_s).to eq(
          @sector.symbol.colorize(@sector.color)
        )
      end
    end

    describe "alternate_to_s" do
      before { @sector = build(:sector) }

      it do
        expect(@sector.alternate_to_s).to eq(
          @sector.alternate_symbol.colorize(@sector.alternate_color)
        )
      end
    end
  end
end
