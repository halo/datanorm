# frozen_string_literal: true

module Datanorm
  module Lines
    # Object that represents one line of a Datanorm file.
    class Base
      # Array that holds the attributes of one line.
      # If there are no semicolons, this Array has only one long String in it.
      attr_reader :columns, :source_line_number

      def initialize(columns:, source_line_number:)
        @columns = columns
        @source_line_number = source_line_number
      end

      # Usually a product number.
      # Multiple lines can have the same ID (e.g. one for price and several for description).
      # Text records can also have their own IDs and they don't equal the product number.
      # Overridden in subclasses.
      def id
        '?'
      end

      # E.g. "T", "A"
      def kind
        columns[0]
      end

      # Overridden in subclasses.
      def to_s
        "[#{id}] UNKNOWN #{columns}"
      end

      def to_json(...)
        as_json.to_json(...)
      end

      def encode(thing)
        return if thing.nil? || thing.to_s.empty?

        thing.to_s.encode('UTF-8')
      end

      # Type querying. Overridden in subclass to return true.

      def header?
        false
      end

      def product?
        false
      end

      def extra?
        false
      end

      def times?
        false
      end

      def dimension?
        false
      end

      def text?
        false
      end

      def price?
        false
      end

      def discount?
        false
      end
    end
  end
end
