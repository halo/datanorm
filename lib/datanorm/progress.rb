# frozen_string_literal: true

module Datanorm
  # Represents how much processing elapsed and how much is left to be done.
  class Progress
    include Datanorm::Logging

    attr_accessor :title, :current, :total

    def increment!
      self.current += 1
    end

    def to_s
      "#{percentage}% (#{title} #{current}/#{total})"
    end

    def significant?
      (current % 50_000).zero?
    end

    def percentage
      ((current.to_f / total) * 100).round(1)
    end
  end
end
