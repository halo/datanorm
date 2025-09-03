# frozen_string_literal: true

module Datanorm
  module Helpers
    # Converts a String to something suitable for a filename.
    class Filename
      include Calls

      param :input

      def call
        "#{Base64.urlsafe_encode64(input.to_s)}.txt"
      end
    end
  end
end
