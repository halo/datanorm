# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Converts a single DATANORM v4 line into a Ruby Object.
      class Parse
        include Calls

        CLASSES = {
          'A' => Datanorm::Lines::V4::Product,
          'B' => Datanorm::Lines::V4::Extra,
          'D' => Datanorm::Lines::V4::Dimension,
          'T' => Datanorm::Lines::V4::Text
          # 'P' => Datanorm::Lines::V4::Price,
        }.freeze

        option :columns
        option :line_number

        def call
          klass = CLASSES.fetch(columns.first[0], Datanorm::Lines::Base)
          klass.new(columns:, line_number:)
        end
      end
    end
  end
end
