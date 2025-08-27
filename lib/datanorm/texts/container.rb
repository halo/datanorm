module Datanorm
  module Texts
    class Container
      def initialize
        @texts = {}
      end

      def add(row:)
        @texts[row.id] ||= []
        @texts[row.id] << row
        nil
      end

      def remove(id)
        @texts.extract!(id)&.values&.first
      end
    end
  end
end
