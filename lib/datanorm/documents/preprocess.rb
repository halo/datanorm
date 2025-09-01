# frozen_string_literal: true

module Datanorm
  module Documents
    # Takes an entire Datanorm file and writes many small text files from it
    # so that the content can later be iterated over in an efficient way.
    class Preprocess
      include Calls
      include ::Datanorm::Logging

      option :file
      option :workdir

      def call
        FileUtils.mkdir_p(workdir)

        file.each do |record|
          ::Datanorm::Documents::Preprocesses::Process.call(workdir:, record:)

          progress.increment!
          yield progress
        end
      end

      private

      def progress
        @progress ||= ::Datanorm::Progress.new.tap do |progress|
          progress.title = 'Preprocessing'
          progress.current = 0
          progress.total = file.lines_count
        end
      end
    end
  end
end
