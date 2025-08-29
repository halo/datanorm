# frozen_string_literal: true

module Datanorm
  # Loads and parses a datanorm file product by product.
  # Each product may be partial (e.g. only price or name or description).
  # It's optimized for memory-efficiency, you must consolidate partial records yourself
  # if you're reading in a single file that's multiple gigabytes large.
  class Document
    include Datanorm::Logging

    def initialize(path:, project_id: SecureRandom.uuid)
      @path = path
      @project_id = project_id
    end

    def header
      file.header
    end

    def version
      file.version
    end

    def items(&)
      lines do |pass, row, index|
        if (index % 50_000).zero?
          percentage = ((index.to_f / file.lines_count) * 100).round(1)
          log { "Processing. pass #{pass} #{percentage}% #{index}/#{file.lines_count}" }
        end

        process = ::Datanorm::Documents::Process.call(project_id:, pass:, row:, index:, total_index:)
        yield process if process
      end
    end

    private

    attr_reader :path, :project_id

    def lines
      index = 0

      %i[preprocess standard].each do |pass|
        log { "Beginning pass #{pass}" }

        file.lines do |row|
          index += 1
          yield pass, row, index

          # We assume TEXT records are only at the beginning of the file.
          # As soon as we hit a PRODUCT record, we can end the first pass.
          break if pass == :preprocess && row.product?
        end
      end
    end

    def total_index
      file.lines_count * 2
    end

    def file
      return @file if defined?(@file)

      @file = ::Datanorm::File.new(path:)
    end
  end
end
