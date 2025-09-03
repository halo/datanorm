# frozen_string_literal: true

module Datanorm
  module Headers
    module V4
      # Parses a Vendor from the raw first line of a Datanorm file.
      class Title
        include Calls

        option :line

        def call
          ::Datanorm::Helpers::Utf8.call all_texts
        end

        private

        # Every supplier uses these three text fields differently.
        # Best to return the entire thing.
        def all_texts
          "#{infotext1} #{infotext2} #{infotext3}".gsub(/\s+/, ' ').strip
        end

        def infotext1
          line[8..47]
        end

        def infotext2
          line[48..87]
        end

        def infotext3
          line[88..122]
        end
      end
    end
  end
end
