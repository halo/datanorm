# frozen_string_literal: true

module Datanorm
  module Headers
    module V4
      # Parses a Date from the raw first line of a DATANORM file.
      class Date
        include Calls

        option :line

        def call
          return unless ddmmyy.match?(/\A\d{6}\z/)

          year = (yy < 50 ? 2000 : 1900) + yy
          ::Date.new(year, mm, dd)
        end

        private

        def dd
          ddmmyy[0..1].to_i
        end

        def mm
          ddmmyy[2..3].to_i
        end

        def yy
          ddmmyy[4..5].to_i
        end

        def ddmmyy
          line[2..7]
        end
      end
    end
  end
end
