module Datanorm
  module Rows
    module V5
      class Product < ::Datanorm::Rows::Base
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
          columns[8].to_d / 100
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
