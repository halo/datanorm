# frozen_string_literal: true

require 'test_helper'

class BaseTest < Minitest::Test
  def test_kind_predicate_methods
    price = Datanorm::Lines::V4::Priceset.new(columns: [], source_line_number: 1)

    assert_predicate price, :kind_priceset?
  end

  def test_id
    record = Datanorm::Lines::Base.new(columns: [], source_line_number: 1)

    assert_raises(RuntimeError, 'Implement #id in Datanorm::Lines::Base') { record.id }
  end

  def test_to_json
    record = Datanorm::Lines::Base.new(columns: [], source_line_number: 1)

    assert_raises(RuntimeError, 'Implement #as_json in Datanorm::Lines::Base') { record.to_json }
  end
end
