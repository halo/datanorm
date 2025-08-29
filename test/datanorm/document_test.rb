# frozen_string_literal: true

require 'test_helper'

class DocumentTest < Minitest::Test
  def test_all_header
    TestAsset.all.each do |path|
      file = Datanorm::Document.new(path:)

      assert_includes [4, 5], file.header.version.number
    end
  end

  def test_items
    document = Datanorm::Document.new(path: TestAsset.v5_first_texts_then_products_path)

    # item = document.first

    # assert_predicate item, :product?
  end
end
