# frozen_string_literal: true

module Datanorm
  module Documents
    module Assembles
      # Object wrapper for a single Product with all its attributes.
      class Product
        include ::Datanorm::Logging

        def initialize(json:, workdir:)
          @json = JSON.parse(json, symbolize_names: true)
          @workdir = workdir

          load_files!
        end

        # ------
        # Basics
        # ------

        def id
          json[:id]
        end

        def quantity
          json[:quantity]
        end

        def quantity_unit
          json[:quantity_unit]
        end

        def discount_group
          json[:discount_group]
        end

        # -------
        # Textual
        # -------

        def title
          json[:title]
        end

        def text_id
          json[:text_id]
        end

        def description
          # In theory, the dimension is for this product only
          # and the text shared by several products of the same kind.
          # In practice, those two are not intended for stacking.
          # Instead, we choose one or the other.
          return dimension_content if dimension_content && !dimension_content.strip.empty?

          text_reference.read
        end

        # -----------------------
        # Immediate Price details
        # -----------------------

        def retail_price?
          json[:is_retail_price]
        end

        def wholesale_price?
          json[:is_wholesale_price]
        end

        def cents
          json[:cents]
        end

        # Convenience shortcut.
        def price
          BigDecimal(cents) / 100
        end

        # ------------------------
        # Referenced Price details
        # ------------------------

        def prices
          return @prices if defined?(@prices)

          @prices = price_reference.read&.map do |json|
            ::Datanorm::Documents::Assembles::Price.new(json:)
          end || []
        end

        # ----------------------
        # Calculated Final Price
        # ----------------------

        # The cheapest of all prices is probably what we pay.
        def cheapest_price
          [price, *prices.map(&:price_after_discount)].min
        end

        # The most expensive of all prices is probably what we sell for.
        def most_expensive_price
          [price, *prices.map(&:price)].max
        end

        # -----------------
        # Referenced Extras
        # -----------------

        def matchcode
          extra_reference.read[:matchcode]
        end

        def alternative_id
          extra_reference.read[:alternative_id]
        end

        def ean
          extra_reference.read[:ean]
        end

        def category_id
          extra_reference.read[:category_id]
        end

        # -------
        # Helpers
        # -------

        def to_s
          "<Product #{as_json}>"
        end

        def as_json
          # Adding referenced attributes that were cached to disk during preprocessing.
          json.merge(description:, prices: prices.map(&:as_json)).merge(extra_reference.read)
        end

        def to_json(...)
          as_json.to_json(...)
        end

        private

        attr_reader :json, :workdir

        # The temporary cached files may be deleted quickly, so let's fetch what we need.
        # effectively populates all data we need
        alias load_files! as_json

        def dimension_content
          return @dimension_content if defined?(@dimension_content)

          @dimension_content = begin
            path = workdir.join('D', ::Datanorm::Helpers::Filename.call(id))
            path.read if path.file?
          end
        end

        def text_reference
          return unless text_id

          @text_reference ||= ::Datanorm::Documents::Assembles::Reference.new(
            path: workdir.join('T', ::Datanorm::Helpers::Filename.call(text_id))
          )
        end

        def extra_reference
          @extra_reference ||= ::Datanorm::Documents::Assembles::Reference.new(
            path: workdir.join('B', ::Datanorm::Helpers::Filename.call(id)), parse_json: true
          )
        end

        def price_reference
          @price_reference ||= ::Datanorm::Documents::Assembles::Reference.new(
            path: workdir.join('P', ::Datanorm::Helpers::Filename.call(id)), split_newlines: true
          )
        end
      end
    end
  end
end
