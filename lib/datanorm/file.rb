# frozen_string_literal: true

module Datanorm
  # Loads and parses a datanorm file row by row.
  class File
    include Datanorm::Logging

    def initialize(path:)
      log { "Loading file `#{path}`" }
      @path = path
    end

    def header
      return @header if defined?(@header)

      ::File.open(path, 'r:CP850') do |file|
        first_line = file.gets
        log { 'Parsing header line...' }

        @header = ::Datanorm::Header.new(line: first_line)
      end
    end

    def rows
      line = 0
      ::CSV.foreach(path, **options) do |columns|
        line += 1
        next if line == 1 # Skip header, it's parsed separately

        row = ::Datanorm::Parse.call(columns:, version:)

        yield row, line
      end
    end

    def version
      header.version
    end

    def lines_count
      return @lines_count if defined?(@lines_count)

      log { 'Scanning number of total lines... (this takes about 2 seconds per GB)' }
      @lines_count = ::File.read(path, encoding: Encoding::CP850).scan("\n").length
      log { 'Scan complete' }
      @lines_count
    end

    private

    attr_reader :path

    def options
      {
        encoding: Encoding::CP850,
        col_sep: ';',
        liberal_parsing: true
      }
    end
  end
end
