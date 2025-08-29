# frozen_string_literal: true

module Datanorm
  module Rows
    module V5
      class Parse
        include Calls

        CLASSES = {
          # 'V' => Datanorm::Rows::V5::Header,
          'A' => Datanorm::Rows::V5::Product
          # 'B' => Datanorm::Rows::V5::Extra, # In v4 this has product data, in V5 only DELETION notice.
          # 'T' => Datanorm::Rows::V5::Text,
          # 'D' => Datanorm::Rows::V5::Dimension,
          # 'P' => Datanorm::Rows::V5::Price,
          # 'C' => Datanorm::Rows::Base,
          # 'S' => Datanorm::Rows::Base
        }.freeze

        param :columns

        def call
          klass = CLASSES[columns.first[0]] || Datanorm::Rows::Base
          klass.new(columns)

          # identifier, columns = parse_line
          # row_class = CLASSES[identifier] || Datanorm::Rows::Base
          # row_class.new(columns)
        end

        # def parse_line
        #   # if line.start_with?('V')
        #   #   line = line.strip.rjust(128, ' ')
        #   #   raise 'Invalid V5 header: must be 128 characters' unless line.length == 128

        #   #   [
        #   #     'V',
        #   #     [
        #   #       line[1..6],          # date (DDMMYY)
        #   #       line[7..38].strip,   # sender
        #   #       line[39..70].strip,  # receiver
        #   #       line[71..122].strip, # description
        #   #       '',                  # reserved
        #   #       line[123..124],      # version
        #   #       line[125..127].strip # currency
        #   #     ]
        #   #   ]
        #   # else
        #     # raise 'Invalid V5 row: empty or no identifier' if columns.empty?
        #     # raise "Invalid V5 identifier: #{columns[0]}" unless columns[0].match?(/\A[A-Z]\z/)

        #     [columns[0], columns]
        #   end
        # end
      end
    end
  end
end
