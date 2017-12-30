# frozen_string_literal: true
require "spec_helper"

module Commands
  RSpec.describe Goto, type: [:command, :movement] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        context "when data is valid" do
          context "when insufficent arguments are passed" do
            it "sends the player to coord 0, 0 for their current area" do
              spec_socket_server do
                movement_setup
                send_player_to_area_center(@player)

                subject.new(@player).call("")
                expect(@player.room.x_coord).to be(0)
                expect(@player.room.y_coord).to be(0)
                expect(@player.area).to eq(@area)
              end
            end
          end

          context "when only x and y coordinates are passed" do
            it "sends the player to the coordinates when valid" do
              spec_socket_server do
                movement_setup
                send_player_to_area_center(@player)

                subject.new(@player).call("1 1")
                expect(@player.room.x_coord).to be(1)
                expect(@player.room.y_coord).to be(1)
                expect(@player.area).to eq(@area)
              end
            end
          end

          context "when area is passed" do

          end
        end

        context "when data is invalid" do
          context "when area is passed" do
            context "when area doesn't exist" do
              it "informs the player the planet doesn't exist" do
                spec_socket_server do
                  connection = build(:player_connection)
                  player = connection.player
                  expect(player).to receive(:send_data).with(
                    "The planet foobar does not exist."
                  )
                  subject.new(player).call("0 0 foobar")
                end
              end
            end
          end

          context "when the room passed does not exist in the area" do
            it "informs the user" do
              spec_socket_server do
                movement_setup

                expect(@player).to receive(:send_data).with(
                  "#{@area.name} does not have a room with coords 100000, " \
                  "100000. Area coordinate ranges span from " \
                  "#{@coord_range.min} to #{@coord_range.max}"
                )
                subject.new(@player).call("100000 100000")
              end
            end
          end
        end
      end
    end
  end
end
