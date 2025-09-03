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
          if record.kind_dimension? || record.kind_text?
            cache_longtext

          elsif record.kind_extra?
            cache_json

          elsif record.kind_priceset?
            cache_priceset

          elsif record.kind_product?
            cache_product
          end
        end

        private

        # Record sets with their own unique IDs that can later be referenced by Products.
        def cache_longtext
          log { "Pre-Processing #{record.id}" }
          ::Datanorm::Documents::Preprocesses::Cache.call(
            workdir:,
            namespace: record.record_kind,
            id: record.id,
            target_line_number: record.line_number,
            content: record.content
          )
        end

        def cache_json
          ::Datanorm::Documents::Preprocesses::Cache.call(
            workdir:,
            namespace: record.record_kind,
            id: record.id,
            content: record.to_json
          )
        end

        # One Product has many prices.
        # We create one file per product that has one price per line for that product.
        def cache_priceset
          set_workdir = workdir.join('P')
          FileUtils.mkdir_p(set_workdir)

          record.prices.each do |price|
            set_workdir.join(::Datanorm::Helpers::Filename.call(price.id)).open('a') do |file|
              file.write("#{price.to_json}\n")
            end
          end
        end

        # When preprocessing is done, we'll need to loop throuth each product once.
        # So let's append each product to one file, so that we can go through it later.
        def cache_product
          workdir.join('A.txt').open('a') do |file|
            file.write("#{record.to_json}\n")
          end
        end
      end
    end
  end
end
