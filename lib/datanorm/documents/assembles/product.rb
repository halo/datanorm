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

          text_content
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

          @prices = prices_content&.split("\n")&.map do |json|
            ::Datanorm::Documents::Assembles::Price.new(json:)
          end || []
        end

        # -----------------
        # Referenced Extras
        # -----------------

        def matchcode
          extra_json[:matchcode]
        end

        def alternative_id
          extra_json[:alternative_id]
        end

        def ean
          extra_json[:ean]
        end

        def category_id
          extra_json[:category_id]
        end

        # -------
        # Helpers
        # -------

        def to_s
          "<Product #{as_json}>"
        end

        def as_json
          # Adding referenced attributes that were cached to disk during preprocessing.
          json.merge(description:, prices: prices.map(&:as_json)).merge(extra_json)
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

        def text_content
          return unless text_id
          return @text_content if defined?(@text_content)

          @text_content = begin
            path = workdir.join('T', ::Datanorm::Helpers::Filename.call(text_id))
            path.read if path.file?
          end
        end

        def extra_json
          return @extra_json if defined?(@extra_json)

          @extra_json = begin
            path = workdir.join('B', ::Datanorm::Helpers::Filename.call(id))
            JSON.parse(path.read, symbolize_names: true) if path.file?
          end
        end

        def prices_content
          return @prices_content if defined?(@prices_content)

          @prices_content = begin
            path = workdir.join('P', ::Datanorm::Helpers::Filename.call(id))
            path.read if path.file?
          end
        end
      end
    end
  end
end
