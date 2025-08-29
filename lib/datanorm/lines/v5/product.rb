module Datanorm
  module Lines
    module V5
      class Product < ::Datanorm::Lines::Base
        def to_s
          "[#{id}] Product-5 #{item_title} - EUR #{price}"
        end

        def product?
          true
        end

        def id
          columns[2]
        end

        def text_id
          columns[23]
        end

        def price
          BigDecimal(columns[8]) / 100
        end

        def item_title
          columns[3..4].join(' ').strip
        end

        def quantity_unit
          columns[5]
        end

        def quantity
          columns[6].to_i.nonzero?
        end
      end
    end
  end
end
