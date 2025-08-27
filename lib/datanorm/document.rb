# frozen_string_literal: true

module Datanorm
  # Loads and parses a datanorm file product by product.
  # Each product may be partial (e.g. only price or name or description).
  # It's optimized for memory-efficiency, you must consolidate partial records yourself
  # if you're reading in a single file that's multiple gigabytes large.
  class Document
    include Datanorm::Logging

    def initialize(path:)
      @path = path
    end

    def header
      file.header
    end

    def version
      file.version
    end

    # One common combo is [A], [B], [D] per product throughout the whole file.
    # In that case, the ID is the same for all three.
    #
    # Another variant is to have all [T] at the beginning and then [A] etc. at the end of the file.
    # In that case the IDs of [T] are separate and later referenced in [A].
    def items(&)
      index = 0
      [1, 2].each do |pass|
        log { "Beginning pass #{pass}" }

        file.rows do |row|
          index += 1

          if pass == 1
            yield process_first_pass(row:), index, file.lines_count * 2
          else
            yield process_second_pass(row:), index, file.lines_count * 2
          end
        end
      end
    end

    # def items(&block)
    #   @texts = ::Datanorm::Texts::Container.new
    #   @prices = ::Datanorm::Prices::Container.new
    #   @items = ::Datanorm::Items::Container.new

    #   rows do |row|
    #     if row.text?
    #       @texts.add(row: row)

    #     elsif row.price?
    #       @prices.add(row: row)

    #     elsif row.dimension? || row.extra?
    #       @items.add(row: row)

    #     elsif row.product?
    #       @items.add(row: row)

    #       if @items.buffer_full?
    #         item = @items.shift
    #         inject(item)
    #         block.call item
    #       end
    #     end
    #   end

    #   until @items.empty?
    #     item = @items.shift
    #     inject(item)
    #     block.call(item)
    #   end
    #   nil
    # end

    private

    attr_reader :path

    def process_first_pass(row:)
      row
    end

    def process_second_pass(row:)
      # puts row
    end

    def file
      return @file if defined?(@file)

      @file = ::Datanorm::File.new(path:)
    end

    # # -------
    # # Logging
    # # -------

    # def log(message = nil)
    #   puts message if ENV['DEBUG']
    # end

    # def activity(indicator)
    #   print indicator if ENV['DEBUG']
    # end
  end
end
