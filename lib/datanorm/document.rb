# frozen_string_literal: true

module Datanorm
  # Loads and parses a datanorm file product by product.
  class Document
    include Datanorm::Logging
    include Enumerable

    attr_reader :path

    def initialize(path:)
      @path = path
    end

    def header
      file.header
    end

    def version
      file.version
    end

    def each
      lines do |pass, record, index|
        # if (index % 50_000).zero?
        #   percentage = ((index.to_f / file.lines_count) * 100).round(1)
        #   log { "Processing. pass #{pass} #{percentage}% #{index}/#{file.lines_count}" }
        # end

        process = ::Datanorm::Documents::Process.call(
          project_id:,
          pass:,
          record:,
          index:,
          total_index:
        )

        yield process if process
      end
    end

    def project_id
      @project_id ||= (Time.now.to_f * 1_000_000_000).to_i.to_s
    end

    private

    def lines
      index = 0

      %i[preprocess standard].each do |pass|
        log { "Beginning pass #{pass}" }

        file.lines do |record|
          index += 1
          yield pass, record, index
        end
      end
    end

    def total_index
      file.lines_count * 2 # Two passes
    end

    def file
      return @file if defined?(@file)

      @file = ::Datanorm::File.new(path:)
    end
  end
end
