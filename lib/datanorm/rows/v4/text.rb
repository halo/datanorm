# frozen_string_literal: true

module Datanorm
  module Rows
    module V4
      # Wraps a line of a DATANORM file that represents one line of a product description.
      # Also known as Langtextsatz.
      class Text < ::Datanorm::Rows::Base
        def to_s
          "TEXT [#{id}] <#{line_number}> #{content.encode('UTF-8', 'CP850').gsub("\n", '⏎')}"
        end

        def text?
          true
        end

        def id
          columns[2]
        end

        def line_number
          columns[4].to_i
        end

        def content
          [columns[6], columns[9]].join("\n").strip
        end

        def <=>(other)
          line_number <=> other.line_number
        end
      end
    end
  end
end
