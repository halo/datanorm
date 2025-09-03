# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/focus'

module TestAsset
  def self.all
    Pathname.new(__dir__).join('assets').glob('*.001').map(&:to_s)
  end

  def self.v4_with_texts
    File.join(__dir__, 'assets/v4_with_texts.001')
  end

  def self.v4_products_before_texts
    File.join(__dir__, 'assets/v4_products_before_texts.001')
  end

  def self.v5_first_texts_then_products
    File.join(__dir__, 'assets/v5_first_texts_then_products.001')
  end

  def self.v4_with_empty_lines_and_invalid_tags
    File.join(__dir__, 'assets/v4_with_empty_lines_and_invalid_tags.001')
  end

  def self.v4_with_missing_text_references
    File.join(__dir__, 'assets/v4_with_missing_text_references.001')
  end
end

require 'datanorm'
