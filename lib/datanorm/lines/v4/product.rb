# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Represents one line containting a product main name, quantity unit and price.
      class Product < ::Datanorm::Lines::Base
        def to_s
          "PRODUCT   [#{id}] <#{title}> " \
            "<#{raw_quantity unless raw_quantity.to_s == quantity} " \
            "<#{quantity}) #{quantity_unit}> EUR #{price} [#{text_id}]"
        end

        def product?
          true
        end

        def id
          columns[2]
        end

        def text_id
          columns[12]
        end

        def price
          BigDecimal(columns[9]) / 100
        end

        def title
          columns[4..5].join(' ').strip
        end

        def quantity_unit
          columns[8]
        end

        def quantity
          case raw_quantity.to_i
          when 0 then 1
          when 1 then 10
          when 2 then 100
          when 3 then 1000
          end
        end

        def as_json
          { id:, text_id:, price:, title:, quantity_unit:, quantity: }
        end

        private

        def raw_quantity
          columns[7]
        end
      end
    end
  end
end
