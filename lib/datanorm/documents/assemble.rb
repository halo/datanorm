# frozen_string_literal: true

module Datanorm
  module Documents
    # Yields every product found in the text files that the preprocessing generated.
    class Assemble
      include Calls
      include ::Datanorm::Logging

      option :workdir

      def call
        return unless products_file.file?

        ::File.foreach(products_file) do |json|
          progress.increment!
          yield progress, ::Datanorm::Documents::Assembles::Product.new(json:, workdir:)
        end
      end

      private

      def products_file
        workdir.join('A.txt')
      end

      def products_count
        return @products_count if defined?(@products_count)

        @products_count = 0
        ::File.foreach(products_file) { @products_count += 1 }
        @products_count
      end

      def progress
        @progress ||= ::Datanorm::Progress.new.tap do |progress|
          progress.current = 0
          progress.total = products_count
        end
      end
    end
  end
end
