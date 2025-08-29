# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'

module TestAsset
  def self.all
    Pathname.new(__dir__).join('assets').glob('*.001').map(&:to_s)
  end

  def self.datanorm4_with_texts_path
    File.join(__dir__, 'assets/datanorm4_with_texts.001')
  end

  def self.v5_first_texts_then_products_path
    File.join(__dir__, 'assets/v5_first_texts_then_products.001')
  end
end

require 'datanorm'
