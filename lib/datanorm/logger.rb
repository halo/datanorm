# frozen_string_literal: true

# A Rubygem to parse DATANORM files from the 90s.
module Datanorm
  # Helper to create a STDOUT logger
  def self.logger
    return @logger if defined?(@logger)

    @logger = ::Logger.new($stdout)
    @logger.formatter = proc do |severity, _, progname, message|
      [severity.rjust(5), progname, '-', message, "\n"].join(' ')
    end
    @logger
  end
end
