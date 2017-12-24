# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  coverage_dir "./tmp/coverage"

  SimpleCov.minimum_coverage 90
  SimpleCov.minimum_coverage_by_file 90
end
