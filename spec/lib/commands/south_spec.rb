# frozen_string_literal: true

module Commands
  RSpec.describe South, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        it "moves the character to the correct room" do
          spec_socket_server { movement_command_spec(subject, 0, 1) }
        end
      end
    end
  end
end
