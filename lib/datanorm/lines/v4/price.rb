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
      #     1=retail/list, 2=wholesale/net (V5 also has 9=ask-for-price)
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

        def retail_price?
          columns[1] == '1'
        end

        def wholesale_price?
          columns[1] == '2'
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
          columns[3] == '2'
        end

        # If this is true, a discount should be applied to `cents`.
        def percentage_discount?
          columns[3] == '1'
        end

        # How much of a discount do we get?
        def discount_percentage
          return unless percentage_discount?

          # 3700 == 37% == 0.37
          BigDecimal(columns[4]) / 100 / 100
        end

        # What is the final price after the discount?
        def discounted_price
          return cents if no_discount?
          raise "Unsupported Discount #{self}" unless percentage_discount?

          price * (1 - discount_percentage)
        end

        # Convenience conversion shortcut.
        def discounted_cents
          (discounted_price * 100).to_i
        end

        # -------
        # Helpers
        # -------

        def to_s
          "<Price #{as_json}>"
        end

        def <=>(other)
          precedence <=> other.precedence
        end

        # So we can distinguish between multiple conflicting prices.
        def precedence
          return 2 if no_discount?
          return 1 if percentage_discount?

          0
        end

        def as_json
          {
            id:,
            cents:,
            discounted_cents:
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
