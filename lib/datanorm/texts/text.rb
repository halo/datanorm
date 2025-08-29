module Datanorm
  module Texts
    class Text
      attr_reader :id, :lines

      def initialize(id:)
        @id = id
        @lines = {}
      end

      def add(row:)
        @lines[row.line_number] = row.content
      end

      def content
        @lines.sort.map(&:last).join(' ')
      end
    end
  end
end
