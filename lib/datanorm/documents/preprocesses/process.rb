# frozen_string_literal: true

module Datanorm
  module Documents
    module Preprocesses
      # Takes one record of a Datanorm file and saves it to disk in an organized way for later use.
      class Process
        include Calls
        include ::Datanorm::Logging

        option :workdir
        option :record

        # One common combo is [A], [B], [D] per product throughout the whole file.
        # In that case, the ID is the same for all three.
        #
        # Another variant is to have all [T] at the beginning and then [A] etc. at the end of the file.
        # In that case the IDs of [T] are separate and later referenced in [A].
        def call
          if record.dimension? || record.text?
            # These are individual records with their own unique IDs and can later be referenced by
            # Products.
            log { "Pre-Processing #{record.id}" }
            ::Datanorm::Documents::Preprocesses::Cache.call(
              workdir:,
              namespace: record.kind,
              id: record.id,
              target_line_number: record.line_number,
              content: record.content
            )

          elsif record.extra?
            ::Datanorm::Documents::Preprocesses::Cache.call(
              workdir:,
              namespace: record.kind,
              id: record.id,
              content: record.to_json
            )
          elsif record.product?
            workdir.join('A.txt').open('a') do |file|
              file.write("#{record.to_json}\n")
            end
          end
        end
      end
    end
  end
end
