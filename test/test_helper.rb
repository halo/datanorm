# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'

module TestAsset
  def self.all
    Pathname.new(__dir__).join('assets').glob('*.001').map(&:to_s)
  end

  def self.v4_with_texts
    File.join(__dir__, 'assets/v4_with_texts.001')
  end
end

require 'datanorm'
