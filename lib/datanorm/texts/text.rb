module Datanorm
  module Texts
    class Text
      attr_reader :id, :rows

      def initialize(id:)
        @id = id
        @rows = {}
      end

      def add(row:)
        @rows[row.line_number] = row.content
      end

      def content
        @rows.sort.map(&:last).join(' ')
      end
    end
  end
end
