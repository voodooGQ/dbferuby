# frozen_string_literal: true
require "spec_helper"

RSpec.describe Movement, type: [:service] do
  include_context "socket"
  let(:subject) { described_class }

  describe "class_methods" do
    describe "call" do
      it "sends a message to the user informing they can't go that direction" do
        spec_socket_server do
          player = create(:player)
          allow(player.area).to receive(:room_by_coords).and_return(nil)
          expect(player).to receive(:send_data).with("You can't go that way!")
          subject.call(player, x:1, y:1)
        end
      end
    end
  end
end
