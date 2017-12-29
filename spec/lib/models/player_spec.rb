# frozen_string_literal: true
require "spec_helper"

RSpec.describe Player, type: [:model] do
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
  end

  describe "class_methods" do
    describe "race_list" do
      it { expect(subject.race_list).to eq(subject::VALID_RACES.join(", ")) }
    end
  end
end
