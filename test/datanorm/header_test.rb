# frozen_string_literal: true

require 'test_helper'

class HeaderTest < Minitest::Test
  def test_invalid
    line = 'V '

    header = Datanorm::Header.new(line:)

    assert_equal(-1, header.version.number)
    refute_predicate header.version, :four?
    refute_predicate header.version, :five?
    assert_nil header.date
  end

  def test_v3
    line = 'V 050321                                                                                                                   03EUR' # rubocop:disable Layout/LineLength

    header = Datanorm::Header.new(line:)

    assert_equal(-1, header.version.number) # Not supported
    refute_predicate header.version, :four?
    refute_predicate header.version, :five?
    assert_nil header.date
  end

  def test_minimal_v4
    line = 'V 050321                                                                                                                   04EUR' # rubocop:disable Layout/LineLength

    header = Datanorm::Header.new(line:)

    assert_equal 4, header.version.number
    assert_predicate header.version, :four?
    refute_predicate header.version, :five?
    assert_equal Date.new(2021, 3, 5), header.date
  end

  def test_misleading_v5
    line = 'V 050321                                                                                                                   05EUR' # rubocop:disable Layout/LineLength

    header = Datanorm::Header.new(line:)

    assert_equal(-1, header.version.number)
    refute_predicate header.version, :four?
    refute_predicate header.version, :five?
  end

  def test_v4_with_date
    line = 'V 060924V4_GST_20241001                         Siemens AG                              AC                                 04EUR' # rubocop:disable Layout/LineLength

    header = Datanorm::Header.new(line:)

    assert_equal 4, header.version.number
    assert_predicate header.version, :four?
    refute_predicate header.version, :five?
    assert_equal Date.new(2024, 9, 6), header.date
  end

  def test_v4_with_date2
    line = 'V 310725(C) xxxxxxx KG, xxxxxx                  Preispflege Datanorm                                                       04EUR' # rubocop:disable Layout/LineLength

    header = Datanorm::Header.new(line:)

    assert_predicate header.version, :four?
    refute_predicate header.version, :five?
    assert_equal Date.new(2025, 7, 31), header.date
  end

  def test_v5
    line = 'V;050;A;20250812;EUR;Artikelstammdaten Deutschland, 38_DE;;TELENOT;TELENOT ELECTRONIC GMBH;www.telenot.de;info@telenot.de;Wiesentalstr. 60;D;73434;Aalen-Hammerstadt;' # rubocop:disable Layout/LineLength

    header = Datanorm::Header.new(line:)

    assert_predicate header.version, :five?
    refute_predicate header.version, :four?
    assert_equal Date.new(2025, 8, 12), header.date
  end
end
