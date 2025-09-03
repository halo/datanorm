# frozen_string_literal: true

module Datanorm
  # Loads and parses a datanorm file product by product.
  class Document
    include Datanorm::Logging
    include Enumerable

    attr_reader :path

    def initialize(path:, timestamp: nil)
      @path = path

      if timestamp
        # Re-use an existing workdir in case the preprocessing was already done earlier.
        @timestamp = timestamp
        @preprocessed = true
      else
        @timestamp = (Time.now.to_f * 1_000_000_000).to_i.to_s # Timestamp with nanoseconds
      end
    end

    def header
      file.header
    end

    def version
      file.version
    end

    def each(yield_progress: false, &)
      unless @preprocessed
        ::Datanorm::Documents::Preprocess.call(file:, workdir:, yield_progress:, &)
        @preprocessed = true
      end

      ::Datanorm::Documents::Assemble.call(workdir:, yield_progress:, &)
    ensure
      # At this point all yields have gone through and we can clean up.
      workdir.rmtree unless ENV['DEBUG_DATANORM']
    end

    def workdir
      @workdir ||= Pathname.new('/tmp/datanorm_ruby').join(@timestamp)
    end

    private

    def file
      return @file if defined?(@file)

      @file = ::Datanorm::File.new(path:)
    end
  end
end
