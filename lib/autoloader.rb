# frozen_string_literal: true

lib_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob("#{lib_root}/**/*.rb", &method(:require))
