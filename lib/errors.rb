# frozen_string_literal: true

# Custom Errors Module
module Errors
  class Base < StandardError; end
  class UnadvisedRoomCreation < Base; end
  class MissingRoom < Base; end
end
