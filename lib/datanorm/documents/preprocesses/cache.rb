# frozen_string_literal: true

module Datanorm
  module Documents
    module Preprocesses
      # Writes a Datanorm record to disk for later retrieval.
      class Cache
        include Calls
        include ::Datanorm::Logging

        option :workdir, as: :parent_workdir
        option :namespace
        option :id
        option :target_line_number, default: -> { 1 }
        option :content, as: :raw_content # Encoding::CP850

        def call
          do_ensure_workdir
            .on_success { do_read_currently_cached_lines }
            .on_success { do_amend_content }
            .on_success { do_write_to_file }
        end

        def do_ensure_workdir
          return Tron.success :workdir_exists if workdir.directory?

          log { "Creating working dir `#{workdir}`" }
          FileUtils.mkdir_p(workdir)
          Tron.success(:workdir_created)
        end

        def do_read_currently_cached_lines
          if filepath.exist?
            @lines = filepath.readlines(chomp: true)
            Tron.success(:loaded_current_file_content)
          else
            @lines = []
            Tron.success(:nothing_cached_yet)
          end
        end

        def do_amend_content
          # Populate every line up until the wanted line.
          @lines[target_line_number - 1] ||= ''

          # Insert the content
          @lines[target_line_number - 1] = content

          Tron.success(:inserted_content)
        end

        def do_write_to_file
          log { "Writing line(s) at position #{target_line_number} to #{filepath}" }
          filepath.write @lines.join("\n")

          Tron.success :wrote_to_cache
        end

        private

        def content
          raw_content.encode 'UTF-8'
        end

        def filepath
          workdir.join(::Datanorm::Helpers::Filename.call(id))
        end

        def workdir
          namespace_parts = Array(namespace)
          parent_workdir.join(*namespace_parts)
        end
      end
    end
  end
end
