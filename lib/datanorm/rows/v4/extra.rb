module Datanorm
  module Rows
    module V4
      class Extra < ::Datanorm::Rows::Base
        def to_s
          "EXTRA     [#{id}] #{"{#{matchcode}}" unless matchcode.empty?} EAN: #{ean}"
        end

        def extra?
          true
        end

        def id
          columns[2]
        end

        # This is like a tag. E.g. a product category.
        def matchcode
          columns[3].to_s.strip
        end

        def vendor_item_id
          columns[4]
        end

        def ean
          columns[9]
        end
      end
    end
  end
end
