# frozen_string_literal: true

module Datanorm
  module Items
    # Bundles together multiple file lines that belong to the same product.
    class Item
      attr_reader :id

      def initialize(id:)
        @id = id
        @rows = Set.new
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

      def add(row: nil, rows: [])
        puts "Item #{id} gets ROW #{row.inspect} ROWS #{rows.inspect}" if ENV['DEBUG']
        return if rows.blank? && row.blank?

        rows.push(row) if row
        rows.each { @rows.add it }
      end

      def title
        product_row&.item_title.presence
      end

      def description
        description_rows.sort
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
        if discount_rows.present?
          discount_rows.sort.last.target_purchase_price
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

          Text #{text_id} (#{dimension_rows.size} Dimensions)
          #{description}
          ---------------------------------------------------------------
          #{rows.to_a.join("\n")}
          ===============================================================

        STRING
      end

      private

      attr_reader :rows

      def description_rows
        dimension_rows.presence || text_rows
      end

      def product_row
        @rows.detect(&:product?)
      end

      def extra_row
        @rows.detect(&:extra?)
      end

      def dimension_rows
        @rows.select(&:dimension?)
      end

      def text_rows
        @rows.select(&:text?)
      end

      def discount_rows
        @rows.select(&:discount?)
      end
    end
  end
end
