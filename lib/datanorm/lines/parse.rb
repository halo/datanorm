# frozen_string_literal: true

module Datanorm
  module Lines
    # Converts one line of a DATANORM file into a Ruby Object.
    #
    # V: Vorlaufsatz (identifies file metadata, often the first line).
    # K: Kopfsatz (header with catalog or transaction details).
    # A: Artikelsatz (product/product data).
    # B: Zusatzsatz (additional product data, e.g., EAN, packaging).
    # C: Leistungssatz/Konditionensatz (product installation time and public tender descriptions).
    # D: Langtextsatz (long text descriptions).
    # P: Preissatz (price data, often multiple products per line in V5).
    # T: Textbausteinsatz (text modules for descriptions).
    # S: Sonderbedingungssatz (special conditions, less common).
    #
    class Parse
      include Calls

      option :version
      option :columns
      option :source_line_number

      def call
        if version.four?
          ::Datanorm::Lines::V4::Parse.call(columns:, source_line_number:)
        elsif version.five?
          ::Datanorm::Lines::V5::Parse.call(columns:, source_line_number:)
        end
      end
    end
  end
end
