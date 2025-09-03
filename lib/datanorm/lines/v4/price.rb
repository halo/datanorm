# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # A `Priceset` record has one or multiple `Price` records.
      # A price represents one price for one product.
      #
      # Examples:
      #   Q4058352208304;1;39000;1;0
      #   RG601315U1;1;2550;1;5500
      #   100033162;1;28500;;
      #
      # [0] Artikelnummer
      #
      # [1] Preiskennzeichen (analogous to `Datanorm::Lines::V5::Product`)
      #     1=wholesale (higher end-customer price)
      #     2=retail (lower bulk price)
      #     9=ask-for-price (only V5)
      #     Some documentation says this means 1=gross and 2=net but I cannot confirm that,
      #     the prices are always net prices and the retail/wholesale fits the bill.
      #
      # [2] Preis (6 Vorkomma, 2 Nachkommastellen)
      #     Price as Integer (6 digits before the comma, the last two digits represent the fraction)
      #
      # [3] Rabattkennzeichen (0=Rabattgruppe,1=Rabattsatz,2=Multi,3=Teuerungszuschlag)
      #     Discount type
      #     "0"=group [no change]
      #     "1"=rate [price - price * (factor/10000)]
      #     "2"=multiplier [price * (factor/1000)]
      #     "3"=surcharge [price + price * (factor/100)]
      #
      # [4] Rabatt
      class Price
        def initialize(columns:)
          @columns = columns
        end

        # ------
        # Basics
        # ------

        def id
          ::Datanorm::Helpers::Utf8.call columns[0]
        end

        # -----
        # Price
        # -----

        def retail?
          columns[1] == '2'
        end

        def wholesale?
          columns[1] == '1'
        end

        def cents
          columns[2].to_i
        end

        def price
          BigDecimal(cents) / 100
        end

        # --------
        # Discount
        # --------

        # If this is true, then `cents` represents the final price.
        def no_discount?
          return true if columns[3] == '2'

          # Fallback: If not defined, assume no discount.
          columns[3].nil? || columns[3].empty?
        end

        # If this is true, a discount should be applied to `cents`.
        def percentage_discount?
          columns[3] == '1'
        end

        # How much of a discount do we get?
        def discount_percentage_integer
          columns[4]&.to_i
        end

        # -------
        # Helpers
        # -------

        def to_s
          "<Price #{as_json}>"
        end

        # We don't need the Product ID here.
        # Our "parent" Priceset has the ID and all `Price` instances refer to the same product.
        def as_json
          {
            is_retail: retail?,
            is_wholesale: wholesale?,
            is_no_discount: no_discount?,
            is_percentage_discount: percentage_discount?,
            discount_percentage: discount_percentage_integer,
            cents:
          }
        end

        def to_json(...)
          as_json.to_json(...)
        end

        private

        attr_reader :columns
      end
    end
  end
end
