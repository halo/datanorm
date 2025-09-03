# frozen_string_literal: true

require 'test_helper'

class PriceTest < Minitest::Test
  def test_percentage_discount
    line = 'RG601315U1;1;2550;1;5530'

    record = Datanorm::Lines::V4::Price.new(columns: line.split(';'))

    assert_equal 'RG601315U1', record.id
    assert_equal 2550, record.cents
    assert_in_delta(25.50, record.price)
    assert_predicate record, :retail_price?
    refute_predicate record, :wholesale_price?
    assert_in_delta(0.553, record.discount_percentage)
    assert_equal 1139, record.discounted_cents
    assert_in_delta(11.398, record.discounted_price)
  end
end
