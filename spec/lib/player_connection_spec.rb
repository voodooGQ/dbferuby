# frozen_string_literal: true
require "spec_helper"

RSpec.describe PlayerConnection, type: [:socket, :connection] do
  include_context "socket"

  let(:subject) { described_class }
  let(:signature) { rand(1..100) }

  describe "post_init" do
    it "logs a message to stdout" do
      spec_socket_server do
        # No need to call post_init directly as will happen after init
        expect{ subject.new(signature) }.to output(
          "-- someone connected to the echo server!\n"
        ).to_stdout
      end
    end
  end

  describe "process_player" do
    it "adds the player object to the connection" do
      spec_socket_server do
        obj = subject.new(signature)
        player = build(:player)

        obj.process_player(player)
        expect(obj.player).to eq(player)
      end
    end

    it "adds itself to the passed in player" do
      spec_socket_server do
        obj = subject.new(signature)
        player = build(:player)

        obj.process_player(player)
        expect(player.connection).to eq(obj)
      end
    end

    it "assigns a new CommandParser object to the connection and adds the " \
      "player to the parser" do
      spec_socket_server do
        obj = subject.new(signature)
        player = build(:player)

        obj.process_player(player)
        expect(obj.command_parser).to be_a(CommandParser)
        expect(obj.command_parser.player).to eq(player)
      end
    end

    it "calls to the 'add_connection_to_pool' method of the Game instance" do
      spec_socket_server do
        game = Game.instance
        obj = subject.new(signature)
        player = build(:player)

        expect(game).to receive(:add_connection_to_pool).with(obj)
        obj.process_player(player)
      end
    end
  end

  describe "receive_data" do
    context "new_character flag is set" do
      it "calls to the creation_processor" do
        spec_socket_server do
          obj = subject.new(signature)
          obj.new_character = true
          expect(obj.creation_processor).to receive(:call).with("foo")
          obj.receive_data("foo")
        end
      end
    end

    context "new_charcter flag is not set" do
      context "no player is set" do
        context "data passed in is 'new'" do
          it "calls to the creation_processor" do
            spec_socket_server do
              obj = subject.new(signature)
              expect(obj.creation_processor).to receive(:call).with("new")
              obj.receive_data("new")
            end
          end
        end

        context "data is anything other than 'new'" do
          it "calls to the login_processor" do
            spec_socket_server do
              obj = subject.new(signature)
              expect(obj.login_processor).to receive(:call).with("foo")
              obj.receive_data("foo")
            end
          end
        end
      end

      context "player is set" do
        it "calls to the command_parser" do
          spec_socket_server do
            obj = subject.new(signature)
            obj.process_player(build(:player))
            expect(obj.command_parser).to receive(:call).with("foo")
            obj.receive_data("foo")
          end
        end
      end
    end
  end

  describe "close_connection" do

  end

  describe "unbind" do

  end
end
