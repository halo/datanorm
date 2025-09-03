# frozen_string_literal: true

module Datanorm
  module Lines
    module V5
      # Immediate product description texts. Should take precedence over Text records.
      class Dimension < ::Datanorm::Lines::Base
        def to_s
          "[#{id}] DIMENSION-5 - #{columns}"
        end

        def id
          encode columns[2]
        end

        def content
          to_s
        end
      end
    end
  end
end
