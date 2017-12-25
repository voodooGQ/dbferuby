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
  end

end
