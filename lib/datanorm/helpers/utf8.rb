# frozen_string_literal: true

module Datanorm
  module Helpers
    # Converts a String to UTF-8.
    class Utf8
      include Calls

      param :input

      # I sometimes encounter single spaces to indicate nil in Datanorm.
      # So let's filter out those, too.
      def call
        return if input.nil? || input == ' ' || input.to_s.empty?

        input.to_s.encode('UTF-8')
      end
    end
  end
end
