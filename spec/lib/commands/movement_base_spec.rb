# frozen_string_literal: true
require "spec_helper"

# Covered by child specs
module Commands
  RSpec.describe MovementBase, type: [:command, :base] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do; end
  end
end
