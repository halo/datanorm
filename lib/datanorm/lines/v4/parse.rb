# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Converts a single DATANORM v4 line into a Ruby Object.
      class Parse
        include Calls

        CLASSES = {
          # 'V' => Datanorm::Lines::V4::Header,
          'A' => Datanorm::Lines::V4::Product,
          'B' => Datanorm::Lines::V4::Extra,
          'T' => Datanorm::Lines::V4::Text,
          'D' => Datanorm::Lines::V4::Dimension
          # 'P' => Datanorm::Lines::V4::Price,
          # 'C' => Datanorm::Lines::Base,
          # 'S' => Datanorm::Lines::Base
        }.freeze

        option :columns

        def call
          klass = CLASSES[columns.first[0]] || Datanorm::Lines::Base
          klass.new(columns)
        end
      end
    end
  end
end
