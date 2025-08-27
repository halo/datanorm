# frozen_string_literal: true

module Datanorm
  # Adds a convenience method for debug logging.
  module Logging
    def self.included(base)
      base.extend ClassMethods
    end

    # Log helper on class level.
    module ClassMethods
      def log(&)
        return unless ENV['DEBUG_DATANORM']

        ::Datanorm.logger&.debug(to_s, &)
      end
    end

    private

    def log(&)
      return unless ENV['DEBUG_DATANORM']

      ::Datanorm.logger&.debug(self.class.to_s, &)
    end
  end
end
