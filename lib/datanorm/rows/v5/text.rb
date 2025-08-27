module Datanorm
  module Rows
    module V5
      class Text < ::Datanorm::Rows::Base
        def to_s
          "[#{id}] TEXT-5 #{line_number} #{content}"
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
          columns[5]
        end

        def <=>(other)
          line_number <=> other.line_number
        end
      end
    end
  end
end
