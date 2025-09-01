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
    document = Datanorm::Document.new(path: TestAsset.datanorm4_with_texts_path)

    items = document.to_a

    puts items

    assert_operator items.size, :>, 3
  end
end
