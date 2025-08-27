# frozen_string_literal: true

module Datanorm
  module Headers
    module V5
      # Parses a Date from the raw first line of a DATANORM file.
      class Date
        include Calls

        option :line

        def call
          # Date.parse(nil) always returns a valid date, so we need to catch that.
          return unless columns[3]

          ::Date.parse(columns[3])
        end

        def columns
          line.split(';')
        end
      end
    end
  end
end
