# frozen_string_literal: true

module Datanorm
  module Lines
    module V5
      # A price represents one price for one product.
      #
      # Examples:
      #   P;100033152;1;1;28000;06;;;;;;;;
      #   P;VSP-983-B;1;1;3410;BMT;
      #
      class Price
        def to_s
          "<Price id=#{id.inspect} #{discounts.join(' | ')}>"
        end

        def id
          encode columns[2]
        end

        def cents
          columns[4].to_i
        end
      end
    end
  end
end
