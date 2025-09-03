# frozen_string_literal: true

module Datanorm
  module Documents
    module Assembles
      # Convenience helper to read the contents of a file.
      class Reference
        extend Dry::Initializer

        option :path
        option :parse_json, optional: true
        option :split_newlines, optional: true

        def read
          return @read if defined?(@read)

          @read = read!
        end

        private

        def read!
          return unless path.file?

          if parse_json
            read_json!
          elsif path.file?
            read_file!
          end
        end

        def read_file!
          if split_newlines
            path.read.split("\n")
          else
            path.read
          end
        end

        def read_json!
          JSON.parse(path.read, symbolize_names: true)
        end
      end
    end
  end
end
