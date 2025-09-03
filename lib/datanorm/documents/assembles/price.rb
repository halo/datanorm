# frozen_string_literal: true

module Datanorm
  module Documents
    module Assembles
      # Object wrapper for a single Price (that belongs to a Priceset).
      class Price
        attr_reader :as_json

        def initialize(json:)
          @as_json = JSON.parse(json, symbolize_names: true)
        end

        # -----------------
        # Native Attributes
        # -----------------

        def wholesale?
          as_json[:is_wholesale]
        end

        def retail?
          as_json[:is_retail]
        end

        def no_discount?
          as_json[:is_no_discount]
        end

        def percentage_discount?
          as_json[:is_percentage_discount]
        end

        def discount_percentage_integer
          as_json[:discount_percentage]
        end

        def cents
          as_json[:cents].to_i
        end

        # ---------------------
        # Calculated Attributes
        # ---------------------

        def price
          BigDecimal(cents) / 100
        end

        def discount_percentage
          return unless percentage_discount?

          # 3700 == 37% == 0.37
          BigDecimal(discount_percentage_integer) / 100 / 100
        end

        # What is the final price after the discount?
        def price_after_discount
          return price if no_discount?
          return unless discount_percentage

          price * (1 - discount_percentage)
        end

        # Helpers

        def <=>(other)
          precedence <=> other.precedence
        end

        # So we can distinguish between multiple conflicting prices.
        def precedence
          return 2 if no_discount?
          return 1 if percentage_discount?

          0
        end

        def to_s
          "<Price #{as_json}>"
        end
      end
    end
  end
end
