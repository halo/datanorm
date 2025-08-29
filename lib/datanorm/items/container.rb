# frozen_string_literal: true

module Datanorm
  module Items
    class Container
      def initialize
        @items = []
      end

      def add(row:)
        item = find(row.id)

        if item
          item.add(row: row)
          return item
        end

        @items.push ::Datanorm::Items::Item.new(id: row.id)
        @items.last.add(row: row)

        @items.last
      end

      # def find(id)
      #   @items.detect { it.id == id }
      # end

      def buffer_full?
        @items.size > 10
      end

      # def size
      #   @items.size
      # end

      # def empty?
      #   @items.empty?
      # end

      def shift
        raise 'Cannot shift if `#empty?`' if @items.empty?

        @items.shift
      end
    end
  end
end
