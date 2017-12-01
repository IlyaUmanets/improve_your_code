# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class TooManyStatements < BaseDetector
      MAX_ALLOWED_STATEMENTS_KEY = 'max_statements'
      DEFAULT_MAX_STATEMENTS = 5

      def self.default_config
        super.merge(
          MAX_ALLOWED_STATEMENTS_KEY => DEFAULT_MAX_STATEMENTS,
          EXCLUDE_KEY => ['initialize']
        )
      end

      def sniff
        count = context.number_of_statements

        return [] if count <= max_allowed_statements

        message = "Your method has #{count} statements. "\
                  'We propose to use ExtractMethod Pattern'

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

      def max_allowed_statements
        value(MAX_ALLOWED_STATEMENTS_KEY, context)
      end
    end
  end
end
