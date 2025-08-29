# frozen_string_literal: true

module Datanorm
  module Items
    # Bundles together multiple file lines that belong to the same product.
    class Item
      attr_reader :id

      def initialize(id:)
        @id = id
        @lines = Set.new
      end

      def text_id
        product_row&.text_id
      end

      def quantity
        product_row&.quantity
      end

      def quantity_unit
        product_row&.quantity_unit
      end

      def matchcode
        extra_row&.matchcode
      end

      def vendor_item_id
        extra_row&.vendor_item_id
      end

      def add(row: nil, lines: [])
        puts "Item #{id} gets ROW #{row.inspect} ROWS #{lines.inspect}" if ENV['DEBUG']
        return if lines.blank? && row.blank?

        lines.push(row) if row
        lines.each { @lines.add it }
      end

      def title
        product_row&.item_title.presence
      end

      def description
        description_lines.sort
                        .map(&:content)
                        .join("\n")
                        .delete_prefix(title.to_s)
                        .strip
                        .presence
      end

      def purchase_list_price
        product_row&.price
      end

      def target_purchase_price
        if discount_lines.present?
          discount_lines.sort.last.target_purchase_price
        else
          product_row&.price
        end
      end

      def to_s
        <<~STRING
          ===============================================================
          [#{id}] #{title}
          #{quantity} #{quantity_unit} EUR #{purchase_list_price}/#{target_purchase_price}
          ---------------------------------------------------------------
          #{matchcode} [#{vendor_item_id}]

          Text #{text_id} (#{dimension_lines.size} Dimensions)
          #{description}
          ---------------------------------------------------------------
          #{lines.to_a.join("\n")}
          ===============================================================

        STRING
      end

      private

      attr_reader :lines

      def description_lines
        dimension_lines.presence || text_lines
      end

      def product_row
        @lines.detect(&:product?)
      end

      def extra_row
        @lines.detect(&:extra?)
      end

      def dimension_lines
        @lines.select(&:dimension?)
      end

      def text_lines
        @lines.select(&:text?)
      end

      def discount_lines
        @lines.select(&:discount?)
      end
    end
  end
end
