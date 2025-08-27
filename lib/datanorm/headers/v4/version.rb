# frozen_string_literal: true

module Datanorm
  module Headers
    module V4
      # Parses the Version from the raw first line of a DATANORM version 4 file.
      class Version
        include Calls

        option :line

        def call
          return if free_use_byte == ';' # Bail out if likely V5
          return unless version_number == '04' # Bail out if not properly V4

          ::Datanorm::Version.new(number: 4, four?: true, five?: false)
        end

        private

        # V4 can have anything here.
        # V5 is in 99.999% of cases a semicolon.
        def free_use_byte
          line[1]
        end

        # V3 is universally not supported.
        # V4 has '04' at this position
        # V5 doesn't use this and could have anything there.
        def version_number
          line[123..124]
        end
      end
    end
  end
end
