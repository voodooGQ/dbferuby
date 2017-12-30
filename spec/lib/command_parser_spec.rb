# frozen_string_literal: true

RSpec.describe CommandParser, type: [:parser] do
  include_context "socket"

  let(:subject) { described_class }
  let!(:mock_command) do
    module Commands
      class Mock < CommandBase
        def call
          true
        end
      end
    end
  end

  describe "instance_methods" do
    describe "call" do
      xit "instantiates the command class when one exists" do
        spec_socket_server(debug: true) do
          connection = build(:player_connection)
          obj = subject.new(connection.player)
          expect(Commands::Chat).to receive(:new)
          obj.call("chat test")
        end
      end

      it "sends a prompt that the command couldn't be found when it doesn't " \
        "exist" do
        spec_socket_server do
          connection = build(:player_connection)
          obj = subject.new(connection.player)
          expect(connection.player).to receive(:send_data).with(
            "Huh?! foo is not a valid command."
          )
          obj.call("foo")
        end
      end

      it "sends a prompt to supply a command when no command is passed" do
        spec_socket_server do
          connection = build(:player_connection)
          obj = subject.new(connection.player)
          expect(connection.player).to receive(:send_data).with(
            "Please supply a command."
          )
          obj.call("")
        end
      end
    end
  end
end
