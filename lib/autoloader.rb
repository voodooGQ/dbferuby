# frozen_string_literal: true
require "active_record"
require 'pg'
require 'logger'
require 'dotenv'

Dotenv.load

ActiveRecord::Base.logger = Logger.new("log/#{ENV['RUBY_ENV']}.log")
configuration = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection(configuration["#{ENV['RUBY_ENV']}"])

lib_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{lib_root}/**/*.rb", &method(:require))
