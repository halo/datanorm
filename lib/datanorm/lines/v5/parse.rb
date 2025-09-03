# frozen_string_literal: true

module Datanorm
  module Lines
    module V5
      # Converts one line of a Datanorm file to a Ruby object.
      class Parse
        include Calls

        # Note that B-records in v4 contain data, but in V4, they are only DELETION notices.
        CLASSES = {
          'A' => Datanorm::Lines::V5::Product,
          'T' => Datanorm::Lines::V5::Text,
          'D' => Datanorm::Lines::V5::Dimension,
          'P' => Datanorm::Lines::V5::Price
          # 'C' => Datanorm::Lines::V5::Service
        }.freeze

        option :columns
        option :source_line_number

        def call
          klass = CLASSES.fetch(columns.first[0], Datanorm::Lines::Base)
          klass.new(columns:, source_line_number:)
        end
      end
    end
  end
end
