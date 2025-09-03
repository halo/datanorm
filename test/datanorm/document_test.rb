# frozen_string_literal: true

require 'test_helper'

class DocumentTest < Minitest::Test
  def test_all_header
    TestAsset.all.each do |path|
      file = Datanorm::Document.new(path:)

      assert_includes [4, 5], file.header.version.number
    end
  end

  def test_each
    document = Datanorm::Document.new(path: TestAsset.v4_with_texts)
    items = document.map { it }.compact

    assert_equal 2, items.size
    assert_equal '100033152', items[0].id
    assert_equal '100033162', items[1].id
    assert_equal 'DIS-AM 20 BUS Infrarot-Bewegungsmelder', items[0].title
    assert_equal 'DIS-AM 60 BUS Infrarot-Bewegungsmelder', items[1].title
    assert items[0].description.start_with? "Der DIS-AM 20/60 Infrarot-Melder kann \nzur"
    assert_equal 28_500, items[1].cents
    assert_equal 'St.', items[0].quantity_unit
    assert_equal '004.050', items[0].category_id
  end

  def test_progress
    document = Datanorm::Document.new(path: TestAsset.v4_with_texts)

    yields = []
    document.each(yield_progress: true) do |product, progress|
      yields << [product, progress]
    end

    assert_equal 35, yields.size
    assert_equal 35, yields.count(&:last)
    assert_equal 2, yields.count(&:first)
    assert_equal 33, yields[0].last.current
    assert_equal 34, yields[0].last.total
    assert_equal 2, yields[34].last.current
    assert_equal 2, yields[34].last.total
  end

  def test_enumerable
    document = Datanorm::Document.new(path: TestAsset.v4_with_texts)
    items = document.to_a

    assert_equal 2, items.size
    assert_equal '100033152', items[0].id
    assert_equal '100033162', items[1].id
    assert_equal 'DIS-AM 20 BUS Infrarot-Bewegungsmelder', items[0].title
    assert_equal 'DIS-AM 60 BUS Infrarot-Bewegungsmelder', items[1].title
    assert items[0].description.start_with? "Der DIS-AM 20/60 Infrarot-Melder kann \nzur"
    assert_equal 28_500, items[1].cents
    assert_equal 'St.', items[0].quantity_unit
    assert_equal '004.050', items[0].category_id
  end

  def test_pricesets
    document = Datanorm::Document.new(path: TestAsset.v4_products_before_texts)
    items = document.map { it }.compact

    assert_equal 2, items.size

    assert_equal 'QATA207569016', items[0].id
    assert_equal 'Tehalit ATA207569016 Endstück schnittkaschierend ABS halogenfreiz.LFW',
                 items[0].title
    assert_equal '00022923', items[0].text_id
    assert_predicate items[0], :retail_price?
    refute_predicate items[0], :wholesale_price?
    assert_equal 300, items[0].cents
    assert_in_delta(3, items[0].price)
    assert_equal 1, items[0].quantity
    assert_equal 'ST', items[0].quantity_unit
    assert_equal '300', items[0].discount_group
    assert_equal "Verwendungszwecke\n- Für Geberit Twinline UP-Spülkästen 12\ncm (ab Baujahr " \
                 "1997 oder ab Baujahr 1988\nmit eingebautem Umbauset auf\n2-Mengen-Spülung)\n- " \
                 "Zum Anschließen von Geberit AquaClean\nWC-Aufsätzen an UP-Spülkästen\n- Zum " \
                 "Anschließen von Geberit AquaClean\n4000 an UP-Spülkästen\n- Zum Anschließen " \
                 "von Geberit AquaClean\n5000 und Geberit AquaClean 5000plus an\nUP-Spülkästen\n" \
                 "- Zum Anschließen von Geberit AquaClean\nTuma WC-Aufsätzen\n- Für Geberit " \
                 "Sigma UP-Spülkästen 12 cm\n- Für vollflächig geflieste Oberflächen",
                 items[0].description
    assert_equal 'HAGER', items[0].matchcode
    assert_equal '3602101', items[0].alternative_id
    assert_nil items[0].ean

    assert_equal 2, items[0].prices.size

    assert_predicate items[0].prices[0], :wholesale?
    assert_predicate items[0].prices[0], :percentage_discount?
    assert_equal 240, items[0].prices[0].cents
    assert_in_delta(2.4, items[0].prices[0].price)
    assert_in_delta(2.4, items[0].prices[0].price_after_discount)
    refute_predicate items[0].prices[0], :retail?
    refute_predicate items[0].prices[0], :no_discount?

    assert_predicate items[0].prices[1], :retail?
    assert_predicate items[0].prices[1], :no_discount?
    assert_equal 88, items[0].prices[1].cents
    assert_in_delta(0.88, items[0].prices[1].price)
    assert_in_delta(0.88, items[0].prices[1].price_after_discount)
    refute_predicate items[0].prices[1], :wholesale?
    refute_predicate items[0].prices[1], :percentage_discount?

    assert_in_delta(0.88, items[0].cheapest_price)
    assert_equal 3, items[0].most_expensive_price

    assert_equal 'QBMK10208R', items[1].id
    assert_equal 'Tehalit LF2002009016 LF-Kanal 20x20 vws LF-Kanal, PVC, verkehrsweiß',
                 items[1].title
    assert_nil items[1].text_id
    assert_predicate items[1], :retail_price?
    refute_predicate items[1], :wholesale_price?
    assert_equal 240, items[1].cents
    assert_in_delta(2.4, items[1].price)
    assert_equal 1, items[1].quantity
    assert_equal 'M', items[1].quantity_unit
    assert_equal '240', items[1].discount_group
    assert_equal "Installationskabel zur Nachrichten- und\nSignalübertragung auf und unter " \
                 "Putz, in\ntrockenen und feuchten Räumen sowie zur\nfesten Verlegung an " \
                 "Außenwänden bei Sch\nutz vor Sonneneinstrahlung. Durch den Ma\nntelaufdruck " \
                 "ist dieses Kabel speziell f\nür die Verwendung in Brandmeldeanlagen\n",
                 items[1].description

    assert_equal 1, items[1].prices.size

    assert_predicate items[1].prices[0], :wholesale?
    assert_predicate items[1].prices[0], :percentage_discount?
    assert_equal 228_313, items[1].prices[0].cents
    assert_in_delta(2283.13, items[1].prices[0].price)
    assert_in_delta(0.76, items[1].prices[0].discount_percentage)
    assert_in_delta(547.9512, items[1].prices[0].price_after_discount)
    refute_predicate items[1].prices[0], :retail?
    refute_predicate items[1].prices[0], :no_discount?

    assert_in_delta(2.4, items[1].cheapest_price)
    assert_in_delta(2283.13, items[1].most_expensive_price)
  end
end
