# frozen_string_literal: true

RSpec.describe CreationProcess, type: [:process] do
  include_context "socket"
  let(:subject) { described_class }

  def setup
    @connection = build(:player_connection)
    @obj = subject.new(@connection)
  end

  def populate_variables(object)
    object.instance_variable_set(:@name, "foobarbazzer")
    object.instance_variable_set(:@password, "foobar")
    object.instance_variable_set(:@password_confirm, "foobar")
    object.instance_variable_set(:@race, Player::VALID_RACES.first)
  end

  describe "instance_methods" do
    describe "call" do
      it "calls to the welcome method" do
        spec_socket_server do
          setup
          expect(@obj).to receive(:welcome)
          @obj.call("new")
        end
      end

      it "calls to the set_name method" do
        spec_socket_server do
          setup
          expect(@obj).to receive(:set_name).with("foo")
          @obj.call("foo")
        end
      end

      it "calls to the set_password method" do
        spec_socket_server do
          setup
          @obj.instance_variable_set(:@name, "foo")
          expect(@obj).to receive(:set_password).with("bar")
          @obj.call("bar")
        end
      end

      it "calls to the set_password_confirm method" do
        spec_socket_server do
          setup
          @obj.instance_variable_set(:@name, "foo")
          @obj.instance_variable_set(:@password, "bar")
          expect(@obj).to receive(:set_password_confirm).with("bar")
          @obj.call("bar")
        end
      end

      it "calls to the set_race method" do
        spec_socket_server do
          setup
          race = Player::VALID_RACES.first
          @obj.instance_variable_set(:@name, "foo")
          @obj.instance_variable_set(:@password, "bar")
          @obj.instance_variable_set(:@password_confirm, "bar")
          expect(@obj).to receive(:set_race).with(race)
          @obj.call(race)
        end
      end
    end

    describe "welcome" do
      it "sends a welcome prompt to the player connection" do
        spec_socket_server do
          setup
          expect(@connection).to receive(:send_data).with(
            "Welcome! What would you like for your character name?\n"
          )
          @obj.welcome
        end
      end

      it "sets the 'new_character' attribute of the connection to true" do
        spec_socket_server do
          setup
          expect(@connection.new_character).to be_falsey
          @obj.welcome
          expect(@connection.new_character).to be_truthy
        end
      end
    end

    describe "set_name" do
      it "sends a notice if a Player with the specified name exists" do
        spec_socket_server do
          setup
          expect(@connection).to receive(:send_data).with(
            "Sorry, a player named #{@connection.player.name} already exists\n"
          )
          @obj.set_name(@connection.player.name)
        end
      end

      context "when the Player with the specified name does not exist" do
        it "sets the name variable" do
          spec_socket_server do
            setup
            expect(@obj.name).to be(nil)
            @obj.set_name("foo")
            expect(@obj.name).to eq("foo")
          end
        end

        it "sends a prompt asking for character password" do
          spec_socket_server do
            setup
            expect(@connection).to receive(:send_data).with(
              "New character (foo). What would you like for your password?\n"
            )
            @obj.set_name("foo")
          end
        end
      end
    end

    describe "set_password" do
      context "when the password is below 6 characters" do
        it "sends an error prompt to the player" do
          spec_socket_server do
            setup
            expect(@connection).to receive(:send_data).with(
              "Passwords must be at least 6 characters long. Password?\n"
            )
            @obj.set_password("foo")
          end
        end
      end

      context "when the password is above 6 characters" do
        it "sets the password variable" do
          spec_socket_server do
            setup
            expect(@obj.password).to be(nil)
            @obj.set_password("foobar")
            expect(@obj.password).to be("foobar")
          end
        end

        it "sends a prompt to the player to confirm their password" do
          spec_socket_server do
            setup
            expect(@connection).to receive(:send_data).with(
              "Please confirm your password: "
            )
            @obj.set_password("foobar")
          end
        end
      end
    end

    describe "set_password_confirm" do
      context "when the passed in does not match the password variable" do
        it "sends an error prompt to the user" do
          spec_socket_server do
            setup
            @obj.instance_variable_set(:@password, "foobar")
            expect(@connection).to receive(:send_data).with(
              "The password confirmation you entered did not match the " \
              "first password entered. Please provide your password again.\n"
            )
            @obj.set_password_confirm("barbaz")
          end
        end

        it "nilifies the password variable" do
          spec_socket_server do
            setup
            @obj.instance_variable_set(:@password, "foobar")
            expect(@obj.password).to eq("foobar")
            @obj.set_password_confirm("barbaz")
            expect(@obj.password).to eq(nil)
          end
        end
      end

      context "when the passed in matches the password variable" do
        it "sets the password_confirm variable" do
          spec_socket_server do
            setup
            @obj.instance_variable_set(:@password, "foobar")
            expect(@obj.password_confirm).to eq(nil)
            @obj.set_password_confirm("foobar")
            expect(@obj.password_confirm).to eq("foobar")
          end
        end

        it "sends a prompt to select the chracters race" do
          spec_socket_server do
            setup
            @obj.instance_variable_set(:@password, "foobar")
            expect(@connection).to receive(:send_data).with(
              "What race is your character? Valid races are: " \
              "#{Player.race_list}\n"
            )
            @obj.set_password_confirm("foobar")
          end
        end
      end
    end

    describe "set_race" do
      context "when the race passed is not valid" do
        it "sends an error prompt to the player" do
          spec_socket_server do
            setup
            expect(@connection).to receive(:send_data).with(
              "The race you selected is not available. Available races are: " \
              "#{Player.race_list}"
            )
            @obj.set_race("foo")
          end
        end
      end

      context "when the race passed is valid" do
        it "sets the race variable to the race passed" do
          spec_socket_server do
            setup
            populate_variables(@obj)
            valid_race = Player::VALID_RACES.last
            @obj.set_race(valid_race)
            expect(@obj.race).to be(valid_race)
          end
        end
      end
    end
  end
end
