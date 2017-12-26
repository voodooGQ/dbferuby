# frozen_string_literal: true
require "active_record"
require 'pg'
require 'logger'
require 'dotenv'

Dotenv.load

env = ENV["RUBY_ENV"] || "development"

ActiveRecord::Base.logger = Logger.new("log/#{env}.log")
configuration = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration["#{env}"])

lib_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{lib_root}/**/*.rb", &method(:require))
