# frozen_string_literal: true

module Datanorm
  # Parses a datanorm file line by line.
  class File
    include Datanorm::Logging

    def initialize(path:)
      log { "Loading file `#{path}`" }
      @path = path
    end

    def header
      return @header if defined?(@header)

      ::File.open(path, "r:#{Encoding::CP850}") do |file|
        first_line = file.gets
        log { 'Parsing header line...' }

        @header = ::Datanorm::Header.new(line: first_line)
      end
    end

    def lines
      line_number = 0

      ::CSV.foreach(path, **options) do |columns|
        line_number += 1
        next if line_number == 1 # Skip header, it's parsed separately

        yield ::Datanorm::Lines::Parse.call(version:, columns:, line_number:)
      end
    end

    # We want this, so that we can indicate how much progress has been done.
    def lines_count
      return @lines_count if defined?(@lines_count)

      log { 'Scanning number of total lines... (this takes about 2 seconds per GB)' }
      @lines_count = ::File.read(path, encoding: Encoding::CP850).scan("\n").length
      log { "Scan complete, counted #{@lines_count} lines." }
      @lines_count
    end

    # Convenience shortcut.
    def version
      header.version
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
