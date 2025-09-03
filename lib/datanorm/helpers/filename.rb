# frozen_string_literal: true

module Datanorm
  module Helpers
    # Converts a String to something suitable for a filename.
    class Filename
      include Calls

      param :input

      def call
        raise "Should not write to file called `#{input.inspect}`" if input.nil?

        # In case there are special characters in a product number.
        utf8_encoded = ::Datanorm::Helpers::Utf8.call(input)
        "#{Base64.urlsafe_encode64(utf8_encoded.to_s)}.txt"
      end
    end
  end
end
