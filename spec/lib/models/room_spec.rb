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
    describe "create" do
      it "overrides the method to raise an error that it should not be " \
        "created manually" do
        expect {
          subject.create(
            x_coord: 0, y_coord: 0, sector: create(:sector), area: create(:area)
          )
        }.to raise_error{
          Errors::UnadvisedRoomCreation
        }.with_message(
          Room::CREATION_ERROR_MSG
        )
      end
    end

    describe "create!" do
      it "overrides the method to raise an error that it should not be " \
        "created manually" do
        expect {
          subject.create!(
            x_coord: 0, y_coord: 0, sector: create(:sector), area: create(:area)
          )
        }.to raise_error{
          Errors::UnadvisedRoomCreation
        }.with_message(
          Room::CREATION_ERROR_MSG
        )
      end
    end
  end
end
