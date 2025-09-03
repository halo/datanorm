# frozen_string_literal: true

require 'test_helper'

class TheFileTest < Minitest::Test
  def test_all_header
    TestAsset.all.each do |path|
      file = Datanorm::File.new(path:)

      assert_includes [4, 5], file.header.version.number
    end
  end

  def test_v4_header
    file = Datanorm::File.new(path: TestAsset.v4_with_texts)

    assert_equal 4, file.header.version.number
  end

  def test_v4_lines
    file = Datanorm::File.new(path: TestAsset.v4_with_texts)

    lines = file.to_a

    assert_predicate lines[0], :kind_product?
  end

  def test_v4_invalid_lines
    file = Datanorm::File.new(path: TestAsset.v4_with_empty_lines_and_invalid_tags)

    products = file.to_a

    assert_equal 6, products.size
  end
end
