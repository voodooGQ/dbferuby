# frozen_string_literal: true
require "spec_helper"

RSpec.describe Room, type: [:models] do
  let(:subject) { described_class }

  describe "instance_methods" do
    describe "custom_validations" do
      describe "unique_coordinates_by_area" do
        it "adds to 'errors' when the x_coord and y_coord combination " \
          "already exists" do
          area = create(:area)
          new_room = subject.new(
            x_coord: 0, y_coord: 0, sector: create(:sector), area: area
          )
          expect(new_room.errors).to receive(:add)
          new_room.save!
        end
      end
    end
  end

  describe "class_methods" do

  end

end
