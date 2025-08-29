module Datanorm
  module Lines
    module V5
      class Dimension < ::Datanorm::Lines::Base
        def to_s
          "[#{id}] DIMENSION-5 - #{columns}"
        end

        def dimension?
          true
        end

        def id
          columns[2]
        end

        def content
          to_s
        end
      end
    end
  end
end
