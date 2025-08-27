module Datanorm
  module Rows
    module V4
      class Extra < ::Datanorm::Rows::Base
        def to_s
          "EXTRA     [#{id}] #{"{#{matchcode}}" if matchcode}"
        end

        def extra?
          true
        end

        def id
          columns[2]
        end

        # This is like a tag. Like a product category.
        def matchcode
          columns[3]
        end

        def vendor_item_id
          columns[4]
        end
      end
    end
  end
end
