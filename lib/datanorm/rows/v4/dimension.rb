module Datanorm
  module Rows
    module V4
      class Dimension < ::Datanorm::Rows::Base
        def to_s
          "DIMENSION [#{id}] #{line_number.to_s.rjust(3)} #{content.encode('UTF-8', 'CP850').gsub("\n", '⏎')}"
        end

        def dimension?
          true
        end

        def id
          columns[2]
        end

        def line_number
          columns[3].to_i
        end

        def content
          [columns[6], columns[10]].join("\n")
        end

        def <=>(other)
          line_number <=> other.line_number
        end
      end
    end
  end
end
