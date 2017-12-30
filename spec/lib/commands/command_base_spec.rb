# frozen_string_literal: true
require "spec_helper"

module Commands
  RSpec.describe CommandBase, type: [:command, :base] do
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "policy" do
        it "returns true by default" do
          expect(subject.new(instance_double("player")).policy).to be_truthy
        end
      end

      describe "initiator_is_authorized?" do
        it "is an alias for policy" do
          obj = subject.new(instance_double("player"))
          expect(obj).to receive(:policy)
          obj.initiator_is_authorized?
        end
      end
    end
  end
end
