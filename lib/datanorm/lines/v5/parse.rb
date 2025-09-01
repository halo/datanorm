# frozen_string_literal: true

module Datanorm
  module Lines
    module V5
      class Parse
        include Calls

        CLASSES = {
          'A' => Datanorm::Lines::V5::Product,
          # 'B' => Datanorm::Lines::V5::Extra, # In v4 this has product data, in V5 only DELETION notice.
          'T' => Datanorm::Lines::V5::Text,
          'D' => Datanorm::Lines::V5::Dimension
          # 'P' => Datanorm::Lines::V5::Price,
          # 'C' => Datanorm::Lines::V5::Service,
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
