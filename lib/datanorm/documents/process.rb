# frozen_string_literal: true

module Datanorm
  module Documents
    class Process
      include Calls
      include ::Datanorm::Logging

      option :project_id
      option :pass
      option :row
      option :index
      option :total_index

      # One common combo is [A], [B], [D] per product throughout the whole file.
      # In that case, the ID is the same for all three.
      #
      # Another variant is to have all [T] at the beginning and then [A] etc. at the end of the file.
      # In that case the IDs of [T] are separate and later referenced in [A].
      def call
        if pass == :preprocess
          preprocess
        else
          standard
        end
      end

      private

      # In the preprocess run, extract all TEXT records.
      # These are individual records with their own unique IDs and can later be referenced by
      # Products.
      def preprocess
        return unless row.text?

        log { "Pre-Processing TEXT #{row}" }
        ::Datanorm::Documents::Cache.call(project_id:,
                                          file_id: row.id,
                                          line_number: row.line_number,
                                          content: row.content)
        # The preprocessing step is never yielded to the user of this Rubygem.
        nil
      end

      def standard
        puts row

        if row.price?
          prices.add(row: row)

        elsif row.dimension? || row.extra?
          items.add(row: row)

        elsif row.product?
          items.add(row: row)

          if items.buffer_full?
            item = items.shift

            # Once we're ready so present a product, we need to amend it with texts and prices.
            inject(item)
            return item
          end
        end

        nil
      end

      def items
        @items ||= ::Datanorm::Items::Container.new
      end

      def prices
        @prices ||= ::Datanorm::Prices::Container.new
      end

      # def items(&block)
      #   @prices = ::Datanorm::Prices::Container.new
      #   @items = ::Datanorm::Items::Container.new

      #   rows do |row|
      #     if row.price?
      #       @prices.add(row: row)

      #     elsif row.dimension? || row.extra?
      #       @items.add(row: row)

      #     elsif row.product?
      #       @items.add(row: row)

      #       if @items.buffer_full?
      #         item = @items.shift
      #         inject(item)
      #         block.call item
      #       end
      #     end
      #   end

      #   until @items.empty?
      #     item = @items.shift
      #     inject(item)
      #     block.call(item)
      #   end
      #   nil
      # end
    end
  end
end
