# frozen_string_literal: true

module Datanorm
  module Documents
    # Takes multiple Text rows (uniquely identified by file_id and line_number)
    # and writes them to disk. One temporary file per product (i.e. multiple text rows).
    class Cache
      include Calls
      include ::Datanorm::Logging

      option :project_id
      option :file_id
      option :line_number
      option :content, as: :raw_content # Encoding::CP850

      def call
        unless workdir.directory?
          log { "Ensuring working dir `#{workdir}` " }
          FileUtils.mkdir_p(workdir)
        end

        # Read existing content or initialize empty array
        lines = filepath.exist? ? filepath.readlines(chomp: true) : []

        # Ensure the array has enough lines
        lines[line_number - 1] ||= '' if line_number.positive?

        # Write or amend the string at the specified line
        lines[line_number - 1] = content

        # Write back to file
        log { "Writing to #{filepath} for Row #{file_id} line #{line_number}" }
        filepath.write "#{lines.join("\n")}\n"
      end

      private

      def content
        raw_content.encode 'UTF-8'
      end

      def filepath
        workdir.join(filename)
      end

      def filename
        "#{Base64.urlsafe_encode64(file_id.to_s)}.txt"
      end

      def workdir
        Pathname.new(::Dir.tmpdir).join(project_id)
      end
    end
  end
end
