# frozen_string_literal: true

module Datanorm
  # Converts one line of a DATANORM file into a Ruby Object.
  class Parse
    include Calls

    option :version
    option :columns

    def call
      if version.five?
        ::Datanorm::Rows::V5::Parse.call(columns:)
      elsif version.four?
        ::Datanorm::Rows::V4::Parse.call(columns:)
      end
    end
  end
end
