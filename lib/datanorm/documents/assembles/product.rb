# frozen_string_literal: true

module Datanorm
  module Documents
    module Assembles
      # Object wrapper for a single Product with all its attributes.
      class Product
        include ::Datanorm::Logging

        def initialize(json:, workdir:)
          @json = JSON.parse(json, symbolize_names: true)
          @workdir = workdir

          load_files!
        end

        def id
          json[:id]
        end

        def title
          json[:title]
        end

        def description
          # In theory, the dimension is for this product only
          # and the text shared by several products of the same kind.
          # In practice, those two are not intended for stacking.
          # Instead, we choose one or the other.
          dimension_content || text_content
        end

        def cents
          json[:cents]
        end

        # Convenience shortcut.
        def price
          BigDecimal(cents / 100)
        end

        def text_id
          json[:text_id]
        end

        def quantity_unit
          json[:quantity_unit]
        end

        # -------
        # Helpers
        # -------

        def to_s
          "<Product #{as_json}>"
        end

        def as_json
          json.merge(
            description:
          )
        end

        def to_json(...)
          as_json.to_json(...)
        end

        private

        attr_reader :json, :workdir

        # The temporary cached files may be deleted quickly, so let's fetch what we need.
        def load_files!
          as_json # effectively populates all data we need
        end

        def dimension_content
          return @dimension_content if defined?(@dimension_content)

          @dimension_content = begin
            path = workdir.join('D', ::Datanorm::Helpers::Filename.call(id))
            path.read if path.file?
          end
        end

        def text_content
          return @text_content if defined?(@text_content)

          @text_content = begin
            path = workdir.join('T', ::Datanorm::Helpers::Filename.call(text_id))
            path.read if path.file?
          end
        end
      end
    end
  end
end

__END__


def matchcode
  extra_row&.matchcode
end

def extra_row
  @lines.detect(&:extra?)
end

def discount_lines
  @lines.select(&:discount?)
end
