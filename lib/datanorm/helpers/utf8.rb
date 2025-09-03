# frozen_string_literal: true

module Datanorm
  module Helpers
    # Converts a String to UTF-8.
    class Utf8
      include Calls

      param :input

      def call
        return if input.nil? || input.to_s.empty?

        input.to_s.encode('UTF-8')
      end
    end
  end
end
