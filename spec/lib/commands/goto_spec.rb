# frozen_string_literal: true
require "spec_helper"

module Commands
  RSpec.describe Goto, type: [:command, :movement] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        context "when no arguments are passed" do
          it "sends the player to coord 0, 0 for their current area" do
            spec_socket_server do
              movement_setup
              @player.room = Room.where(
                "x_coord = ? AND y_coord = ?", 0, 0
              ).first
              subject.new(@player).call("")
              expect(@player.room.x_coord).to be(0)
              expect(@player.room.y_coord).to be(0)
              expect(@player.area).to eq(@area)
            end
          end
        end

        context "when only x and y coordinates are passed" do

        end

        context "when area is passed" do

        end
      end
    end
  end
end
