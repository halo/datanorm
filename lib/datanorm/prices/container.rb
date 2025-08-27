# frozen_string_literal: true

module Datanorm
  module Prices
    class Container
      def initialize
        @discounts = {}
      end

      def add(row:)
        row.discounts.each do |discount|
          @discounts[discount.id] ||= []
          @discounts[discount.id] << discount
        end
        nil
      end

      def remove(id)
        @discounts.extract!(id)&.values&.first
      end
    end
  end
end
