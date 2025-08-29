# frozen_string_literal: true

module Datanorm
  module Headers
    module V5
      # Parses the Version from the raw first line of a DATANORM version 5 file.
      class Version
        include Calls

        option :line

        def call
          # This is an arbitrary number to see if there are enough semicolons
          # to believe that this could be a v5 file.
          return unless columns.size > 3
          return unless version_number == '050'

          ::Datanorm::Version.new(number: 5, four?: false, five?: true)
        end

        private

        # V4 can have anything here.
        # V5 definitely has "050" here.
        # I'm pretty sure that stands for 0.5.0 and no newer version was ever released.
        def version_number
          columns[1]
        end

        def columns
          line.split(';')
        end
      end
    end
  end
end
