# frozen_string_literal: true

require 'test_helper'

class PricesetTest < Minitest::Test
  def test_set
    line = 'P;A;QLI100DALIRO;1;43630;1;3100;;;;;Q150150NWRO;1;38770;1;3100;;;;;Q150153NWRO;1;48290;1;3100;;;;;' # rubocop:disable Layout/LineLength

    record = Datanorm::Lines::V4::Priceset.new(columns: line.split(';'), source_line_number: 1)

    assert_equal 'P', record.record_kind
    assert_raises(
      RuntimeError, 'A Priceset with multiple products does not have one single ID'
    ) { record.id }

    price1 = record.prices[0]

    assert_equal 'QLI100DALIRO', price1.id
    assert_equal 43_630, price1.cents
  end
end
