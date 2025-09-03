# frozen_string_literal: true

module Datanorm
  # Parses a datanorm file line by line and wraps them in Ruby objects.
  class File
    include Datanorm::Logging
    include Enumerable

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

    # Convenience shortcut.
    def version
      header.version
    end

    def each
      line_number = 0

      ::CSV.foreach(path, **options) do |columns|
        line_number += 1
        next if line_number == 1 # Skip header, it's parsed separately
        next if columns.empty? # Empty line

        yield ::Datanorm::Lines::Parse.call(version:, columns:, source_line_number: line_number)
      end
    end

    # We want this, so that we can indicate how much progress has been done.
    def lines_count
      return @lines_count if defined?(@lines_count)

      log { 'Scanning number of total lines... (this takes about 2 seconds per GB)' }
      @lines_count = 0
      # `foreach` doesn't load the entire file into memory.
      ::File.foreach(path, encoding: Encoding::CP850) { @lines_count += 1 }
      log { "Scan complete, counted #{@lines_count} lines." }
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
