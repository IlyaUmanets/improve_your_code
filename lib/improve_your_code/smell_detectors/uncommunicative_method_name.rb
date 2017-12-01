# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class UncommunicativeMethodName < BaseDetector
      REJECT_KEY = 'reject'
      ACCEPT_KEY = 'accept'
      DEFAULT_REJECT_PATTERNS = [/^[a-z]$/, /[0-9]$/, /[A-Z]/].freeze
      DEFAULT_ACCEPT_PATTERNS = [].freeze

      def self.default_config
        super.merge(
          REJECT_KEY => DEFAULT_REJECT_PATTERNS,
          ACCEPT_KEY => DEFAULT_ACCEPT_PATTERNS
        )
      end

      def sniff
        name = context.name.to_s

        return [] if acceptable_name?(name)

        [
          smell_warning(
            context: context,
            lines: [source_line],
            message: "has the name '#{name}'",
            parameters: { name: name }
          )
        ]
      end

      private

      def acceptable_name?(name)
        any_acceptance_patterns?(name) || any_reject_patterns?(name)
      end

      def any_acceptance_patterns?(name)
        accept_patterns.any? { |accept_pattern| name.match accept_pattern }
      end

      def any_reject_patterns?(name)
        reject_patterns.none? { |reject_pattern| name.match reject_pattern }
      end

      def reject_patterns
        Array value(REJECT_KEY, context)
      end

      def accept_patterns
        Array value(ACCEPT_KEY, context)
      end
    end
  end
end
