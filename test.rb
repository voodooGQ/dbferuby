# frozen_string_literal: true

require "pry-byebug"

# Autoloader
lib_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{lib_root}/**/*.rb", &method(:require))

Game.instance.run
