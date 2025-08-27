# frozen_string_literal: true

module Datanorm
  module Rows
    # V: Vorlaufsatz (identifies file metadata, often the first line).
    # K: Kopfsatz (header with catalog or transaction details).
    # A: Artikelsatz (product/product data).
    # B: Zusatzsatz (additional product data, e.g., EAN, packaging).
    # C: Konditionensatz (pricing or discount conditions).
    # D: Langtextsatz (long text descriptions).
    # P: Preissatz (price data, often multiple products per line in V5).
    # T: Textbausteinsatz (text modules for descriptions).
    # S: Sonderbedingungssatz (special conditions, less common).
    class Base
      # Array that holds one single line of the file, separated by semicolons.
      # If there are no semicolons, the Array has only one String in it.
      attr_reader :columns

      def initialize(columns)
        @columns = columns
      end

      # Usually a product number.
      # Multiple rows can have the same ID (e.g. one for price and several for description).
      # Text records can also have their own IDs and they don't equal the product number.
      # Overriden in subclasses.
      def id
        '?'
      end

      # Overriden in subclasses.
      def to_s
        "[#{id}] UNKNOWN #{columns}"
      end

      # Type querying. Overriden in subclass to return true.

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
