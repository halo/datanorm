# frozen_string_literal: true

module Datanorm
  module Headers
    module V5
      # rubocop:disable Layout/LineLength
      #
      # Parses a Vendor from the raw first line of a Datanorm file.
      #
      # Examples:
      #   V;050;A;20200406;EUR;Example GmbH;Produktdaten;;;;;;;;;
      #   V;050;A;20201210;EUR;Produktkatalog 2021;ACME inc.;;;;;;;;;
      #   V;050;A;20200730;EUR;Artikelstammdaten Deutschland, 29_DE;;EXAMPLE;EXAMPLE ELECTRONIC GMBH;www.example.de;info@example.de;Examplestr. 60;D;73434;Examplecity;
      #
      # rubocop:enable Layout/LineLength
      class Title
        include Calls

        option :line

        def call
          ::Datanorm::Helpers::Utf8.call columns[5..14].join(' ').gsub(/\s+/, ' ').strip
        end

        private

        def columns
          line.split(';')
        end
      end
    end
  end
end
