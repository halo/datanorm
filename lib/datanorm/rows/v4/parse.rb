# frozen_string_literal: true

module Datanorm
  module Rows
    module V4
      # Converts a single DATANORM v4 line into a Ruby Object.
      class Parse
        include Calls

        CLASSES = {
          # 'V' => Datanorm::Rows::V4::Header,
          'A' => Datanorm::Rows::V4::Product,
          'B' => Datanorm::Rows::V4::Extra,
          'T' => Datanorm::Rows::V4::Text,
          'D' => Datanorm::Rows::V4::Dimension
          # 'P' => Datanorm::Rows::V4::Price,
          # 'C' => Datanorm::Rows::Base,
          # 'S' => Datanorm::Rows::Base
        }.freeze

        option :columns

        def call
          klass = CLASSES[columns.first[0]] || Datanorm::Rows::Base
          klass.new(columns)
        end
      end
    end
  end
end
