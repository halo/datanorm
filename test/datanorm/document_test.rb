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
    document = Datanorm::Document.new(path: TestAsset.v4_with_texts)
    items = document.map { it }.compact

    assert_equal 2, items.size
    assert_equal '100033152', items[0].id
    assert_equal '100033162', items[1].id
    assert_equal 'DIS-AM 20 BUS Infrarot-Bewegungsmelder', items[0].title
    assert_equal 'DIS-AM 60 BUS Infrarot-Bewegungsmelder', items[1].title
    assert_send [items[0].description, :start_with?, "Der DIS-AM 20/60 Infrarot-Melder kann \nzur"]
    assert_send [items[0].description, :start_with?, "Der DIS-AM 20/60 Infrarot-Melder kann \nzur"]
    assert_equal 28_500, items[1].cents
    assert_equal 28_500, items[0].quantity_unit
  end
end
