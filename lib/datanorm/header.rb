# frozen_string_literal: true

module Datanorm
  # Represents the first line of a DATANORM file.
  #
  # Zeichen 1: Satzkennzeichen für Vorlaufsatz: immer „V“
  # Zeichen 2: freie Verwendung
  # Zeichen 3-8: Datum im Format TTMMJJ, darf für Cadia nicht leer sein
  # Zeichen 9-48: Infotext1 (Bezeichnung des Datenlieferanten), darf für Cadia nicht leer sein
  # Zeichen 49-88: Infotext2
  # Zeichen 89-123: Infotext3
  # Zeichen 124-125: Datanormversion (für Cadia zwingend 04)
  # Zeichen 126-128: Währung (im Regelfall EUR)
  #
  class Header
    def initialize(line:)
      @line = line.to_s
    end

    def to_s
      "HEADER <V#{version.number}> date <#{date}>"
    end

    def version
      return @version if defined?(@version)

      @version = parse_version
    end

    def date
      return @date if defined?(@date)

      @date = parse_date
    end

    def title
      return @title if defined?(@title)

      @title = parse_title
    end

    private

    attr_reader :line

    def parse_version
      # They are mutually exclusive in detecting their own version.
      # I'm willing to bet that there is no canonical exact way to detect it anyway.
      ::Datanorm::Headers::V5::Version.call(line:) ||
        ::Datanorm::Headers::V4::Version.call(line:) ||
        ::Datanorm::Version.new(number: -1, four?: false, five?: false) # Unknown version
    end

    def parse_date
      if version.five?
        ::Datanorm::Headers::V5::Date.call(line:)
      elsif version.four?
        ::Datanorm::Headers::V4::Date.call(line:)
      end
    end

    def parse_title
      if version.five?
        ::Datanorm::Headers::V5::Title.call(line:)
      elsif version.four?
        ::Datanorm::Headers::V4::Title.call(line:)
      end
    end
  end
end
