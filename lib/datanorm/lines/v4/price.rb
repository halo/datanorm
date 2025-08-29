module Datanorm
  module Lines
    module V4
      class Price < ::Datanorm::Lines::Base
        def to_s
          "[#{id}] PRICE-4 #{discounts.join(' | ')}"
        end

        def price?
          true
        end

        def discounts
          [columns[2..6],
           columns[11..15],
           columns[20..24]].map do
            ::Datanorm::Lines::V4::Prices::Discount.new(_1)
          end
        end
      end
    end
  end
end
