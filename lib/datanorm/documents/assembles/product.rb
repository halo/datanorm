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
          load!
        end

        def id
          json[:id]
        end

        def title
          json[:title]
        end

        def description
          @dimension_content || @text_content
        end

        def cents
          json[:cents]
        end

        def text_id
          json[:text_id]
        end

        def to_json(...)
          as_json.to_json(...)
        end

        private

        attr_reader :json, :workdir

        def as_json
          {
            id:,
            title:,
            description:
          }
        end

        def load!
          @dimension_content = dimension_content!
          @text_content = text_content!
        end

        def dimension_content!
          path = workdir.join('D', "#{Base64.urlsafe_encode64(id.to_s)}.txt")
          if path.file?
            path.read
          else
            log { "No dimension found at #{path}" }
            nil
          end
        end

        def text_content!
          path = workdir.join('T', "#{Base64.urlsafe_encode64(text_id.to_s)}.txt")
          if path.file?
            path.read
          else
            log { "No text found at #{path}" }
            nil
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

def vendor_item_id
  extra_row&.vendor_item_id
end

def add(row: nil, lines: [])
  puts "Item #{id} gets ROW #{row.inspect} ROWS #{lines.inspect}" if ENV['DEBUG']
  return if lines.blank? && row.blank?

  lines.push(row) if row
  lines.each { @lines.add it }
end

def title
  product_row&.item_title.presence
end

def description
  description_lines.sort
                  .map(&:content)
                  .join("\n")
                  .delete_prefix(title.to_s)
                  .strip
                  .presence
end

def purchase_list_price
  product_row&.price
end

def target_purchase_price
  if discount_lines.present?
    discount_lines.sort.last.target_purchase_price
  else
    product_row&.price
  end
end

def to_s
  <<~STRING
    ===============================================================
    [#{id}] #{title}
    #{quantity} #{quantity_unit} EUR #{purchase_list_price}/#{target_purchase_price}
    ---------------------------------------------------------------
    #{matchcode} [#{vendor_item_id}]

    Text #{text_id} (#{dimension_lines.size} Dimensions)
    #{description}
    ---------------------------------------------------------------
    #{lines.to_a.join("\n")}
    ===============================================================

  STRING
end

private

attr_reader :lines

def description_lines
  dimension_lines.presence || text_lines
end

def product_row
  @lines.detect(&:product?)
end

def extra_row
  @lines.detect(&:extra?)
end

def dimension_lines
  @lines.select(&:dimension?)
end

def text_lines
  @lines.select(&:text?)
end

def discount_lines
  @lines.select(&:discount?)
end
