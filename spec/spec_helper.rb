# frozen_string_literal: true

require "bundler/setup"
require "pry"
require "pry-byebug"
require "factory_bot"
require "faker"

# Ensure the environment is set to test so we don't catch logs with the rspec
# errors
ENV["RUBY_ENV"] = "test"

# Setup files to add functionality to the test processor. (EX: VCR and SimpleCov
# configurations)
[*Dir.glob("./spec/setup/**/*.rb")].each { |f| require f }

# Main lib MUST come after the simplecov_helper
require_relative "../lib/autoloader"

#  Spec Support features (functionality used in the actual test suite)
[*Dir.glob("./spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.include SpecHelperFunctions, type: :helper

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # Disables legacy 'should' syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Load tests in random order so sequencing is avoided
  config.order = :random

  # Will be the only supported behaviour in 3.4, get it in now
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.mock_with :rspec do |mocks|
    # Don't allow mocking on nil items. Create a non-nil stub/mock in it's place
    mocks.allow_message_expectations_on_nil = false
  end

  # include FactoryBot
  config.include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions if FactoryBot.factories.count == 0
end
