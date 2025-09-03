# frozen_string_literal: true

module Datanorm
  module Lines
    # Object that represents one line of a Datanorm file.
    class Base
      # Array that holds all attributes of one line.
      # In the Datanorm file they are typically separated by seimcolons.
      # Header rows may lack semicolons (in V4), in that case, this Array has only one long String.
      attr_reader :columns

      # Where in the originating Datanorm file this line is located.
      attr_reader :source_line_number

      # This class is subclassed by one type per row.
      # Add convenient predicate methods to query the kind of record class.
      # E.g. `Datanorm::Lines::V4::Extra` has `kind_extra?` to be true.
      def self.inherited(subclass)
        kind_method = "kind_#{subclass.name.split('::').last.downcase}?"

        remove_method(kind_method) if method_defined?(kind_method) # Avoid warnings during tests
        define_method(kind_method) do
          self.class.name.split('::').last.downcase == subclass.name.split('::').last.downcase
        end

        super
      end

      def initialize(columns:, source_line_number:)
        @columns = columns
        @source_line_number = source_line_number
      end

      # Every row has a unique identifier. Most often a product number.
      # Text records commonly have their own IDs, which are not equal to the product number.
      # Multiple lines can have the same ID (e.g. one for price and several for description).
      # Also known as "Satzartenkennzeichen".
      def id
        raise "Implement ##{__method__} in #{self.class}"
      end

      def as_json
        raise "Implement ##{__method__} in #{self.class}"
      end

      # The first character in every line always represents the record type.
      # E.g. "T", "A"
      def record_kind
        columns[0]
      end

      # Overridden in subclasses.
      def to_s
        to_json
      end

      # Convenience Shortcut to convert attributes from CP850 to UTF-8.
      def encode(...)
        ::Datanorm::Helpers::Utf8.call(...)
      end

      def to_json(...)
        as_json.to_json(...)
      end
    end
  end
end
