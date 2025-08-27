# frozen_string_literal: true

require 'test_helper'

class DocumentTest < Minitest::Test
  def test_invalid
    path = File.join(__dir__, '../assets/datpreis_v4_sample.001')

    document = Datanorm::Document.new(path:)

    assert_equal 4, document.header.version.number
  end
end
