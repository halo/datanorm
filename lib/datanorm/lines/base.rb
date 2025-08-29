# frozen_string_literal: true

module Datanorm
  module Lines
    # Object that represents one line of a Datanorm file.
    class Base
      # Array that holds the attributes of one line.
      # If there are no semicolons, this Array has only one long String in it.
      attr_reader :columns

      def initialize(columns:, line_number:)
        @columns = columns
        @line_number = line_number
      end

      # Usually a product number.
      # Multiple lines can have the same ID (e.g. one for price and several for description).
      # Text records can also have their own IDs and they don't equal the product number.
      # Overridden in subclasses.
      def id
        '?'
      end

      # Overridden in subclasses.
      def to_s
        "[#{id}] UNKNOWN #{columns}"
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
