# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class TooManyMethods < BaseDetector
      MAX_ALLOWED_METHODS_KEY = 'max_methods'.freeze
      DEFAULT_MAX_METHODS = 5

      def self.contexts
        [:class]
      end

      def self.default_config
        super.merge(
          MAX_ALLOWED_METHODS_KEY => DEFAULT_MAX_METHODS,
          EXCLUDE_KEY => []
        )
      end

      def sniff
        count = context.node_instance_methods.length

        return [] if count <= max_allowed_methods

        message = "Your class has #{count} methods. "\
                  'We propose to use ExtractClass Pattern'

        [
          smell_warning(
            context: context,
            lines: [source_line],
            message: message,
            parameters: { count: count }
          )
        ]
      end

      private

      def max_allowed_methods
        value(MAX_ALLOWED_METHODS_KEY, context)
      end
    end
  end
end
