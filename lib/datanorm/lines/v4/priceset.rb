# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # rubocop:disable Layout/LineLength
      # Represents one line of the Datanorm file that starts with "P".
      # It contains price data for up to three individual products.
      #
      # Examples:
      #   V4
      #   P;A;Q4058352208304;1;39000;1;0;;;;;Q4058352208304;2;25521;;;;;;;Q4058352208403;1;42300;1;0;;;;;
      #   P;A;RG601315U1;1;2550;1;5500;;;;;RG601215U1;1;2130;1;5500;;;;;RG6211420U1;1;3210;1;5500;;;;;
      #   P;A;100033162;1;28500;;;;;;;;;;;;;;;;;;;;;;;;;
      #
      # rubocop:enable Layout/LineLength
      class Priceset < ::Datanorm::Lines::Base
        def to_s
          "<Priceset with #{prices.size} prices>"
        end

        # Not available at this hierarchy level.
        # The collection contains up to three product IDs.
        def id
          return prices.first.id if prices.size == 1

          raise 'A Priceset with multiple products does not have one single ID'
        end

        def prices
          [columns[2..6],
           columns[11..15],
           columns[20..24]].map do |set_columns|
             next if set_columns[0].to_s == ''

             ::Datanorm::Lines::V4::Price.new(columns: set_columns)
           end.compact
        end
      end
    end
  end
end
