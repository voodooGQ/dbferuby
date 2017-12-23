# frozen_string_literal: true

class CreationProcess
  attr_reader :connection,
              :name,
              :password,
              :password_confirm,
              :race

  def initialize(connection)
    @connection = connection
  end

  def call(data)
    return welcome if data == "new" && !@name
    return set_name(data) unless @name
    return set_password(data) unless @password
    return set_password_confirm(data) unless @password_confirm
    return set_race(data) unless @race
  end

  def welcome
    @connection.send_data "Welcome! What would you like for your character " \
      "name?\n"
    @connection.new_character = true
  end

  def set_name(name)
    if Player.where("lower(name) = ?", name.downcase).any?
      @connection.send_data "Sorry, a player named #{name} already exists\n"
    else
      @name = name
      @connection.send_data "New character (#{name}). " \
        "What would you like for your password?\n"
    end
  end

  def set_password(password)
    if password.size < 6
      @connection.send_data "Passwords must be at least 6 characters long. " \
        "Password?\n"
    else
      @password = password
      @connection.send_data "Please confirm your password: "
    end
  end

  def set_password_confirm(password)
    if password != @password
      @connection.send_data "The password confirmation you entered did not " \
        "match the first password entered. Please provide your password " \
        "again.\n"
    else
      @password_confirm = password
      @connection.send_data "What race is your character? Valid races are: " \
        "#{Player::VALID_RACES.join(", ")}\n"
    end
  end

  def set_race(race)
    unless Player::VALID_RACES.include?(race.downcase)
      @connection.send_data "The race you selected is not available. " \
        "Available races are: #{Player::VALID_RACES.join(', ')}"
    else
      @race = race
      @connection.process_player(
        Player.create!(name: @name, password: @password, race: @race)
      )
      @connection.send_data "New character #{@name} created!"
      @connection.new_character = false
    end
  end
end
