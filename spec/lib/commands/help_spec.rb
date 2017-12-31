# frozen_string_literal: true

module Commands
  RSpec.describe Help, type: [:command] do
    include_context "socket"
    let(:subject) { described_class }

    describe "instance_methods" do
      describe "call" do
        context "when no keyword is passed" do
          it "sends the list of help commands to the user" do
            spec_socket_server do
              player = build(:player_connection).player
              obj = subject.new(player)
              expect(player).to receive(:send_data).with(obj.command_list)
              obj.call([])
            end
          end
        end

        context "when a keyword is passed" do
          context "when the keyword is 'help'" do
            it "sends the help text for the Command" do
              spec_socket_server do
                player = build(:player_connection).player
                obj = subject.new(player)
                expect(player).to receive(:send_data).with(obj.help)
                obj.call(["help"])
              end
            end
          end

          context "when the command for the keyword doesn't exit" do
            it "informs the player that no help is available" do
              spec_socket_server do
                player = build(:player_connection).player
                obj = subject.new(player)
                expect(player).to receive(:send_data).with(
                  "foo is not a valid command. No help topic available."
                )
                obj.call(["foo"])
              end
            end
          end

          context "when the user is not authorized to run the commands " \
            "associated to the keyword" do
            it "informs the player that no help is available" do
              spec_socket_server do
                player = build(:player_connection).player
                obj = subject.new(player)
                expect(player).to receive(:send_data).with(
                  "goto is not a valid command. No help topic available."
                )
                # This is an admin command and will fail for a normal user
                obj.call(["goto"])
              end
            end
          end

          context "when the command responds to the 'help' method" do
            it "responds with the help text" do
              spec_socket_server do
                player = build(:player_connection).player
                obj = subject.new(player)
                expect(player).to receive(:send_data).with(
                  Commands::North.new(player).help
                )
                obj.call(["north"])
              end
            end
          end

          context "when the command does not have a 'help' method" do
            let!(:mock_cmd) do
              class Mock < CommandBase; end
            end

            it "advises the player that the command doesn't have help entry" do
              spec_socket_server do
                player = build(:player_connection).player
                obj = subject.new(player)
                expect(player).to receive(:send_data).with(
                  "mock does not currently have a help entry."
                )
                obj.call(["mock"])
              end
            end
          end
        end
      end

      describe "help" do
        it "returns a help string" do
          expect(subject.new(create(:player)).help).to be_a(String)
        end
      end
    end
  end
end
