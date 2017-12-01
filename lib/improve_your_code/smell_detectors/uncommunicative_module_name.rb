# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class UncommunicativeModuleName < BaseDetector
      REJECT_KEY = 'reject'
      DEFAULT_REJECT_PATTERNS = [/^.$/, /[0-9]$/].freeze
      ACCEPT_KEY = 'accept'
      DEFAULT_ACCEPT_PATTERNS = [].freeze

      def self.default_config
        super.merge(
          REJECT_KEY => DEFAULT_REJECT_PATTERNS,
          ACCEPT_KEY => DEFAULT_ACCEPT_PATTERNS
        )
      end

      def self.contexts
        %i[module class]
      end

      def sniff
        fully_qualified_name = context.full_name
        module_name          = expression.simple_name

        return [] if acceptable_name?(
          module_name: module_name,
          fully_qualified_name: fully_qualified_name
        )

        [
          smell_warning(
            context: context,
            lines: [source_line],
            message: "has the name '#{module_name}'",
            parameters: { name: module_name }
          )
        ]
      end

      private

      def acceptable_name?(module_name:, fully_qualified_name:)
        any_accept_patterns?(module_name) ||
          any_reject_patterns?(fully_qualified_name)
      end

      def any_accept_patterns?(fully_qualified_name)
        accept_patterns.any? do |accept_pattern|
          fully_qualified_name.match accept_pattern
        end
      end

      def any_reject_patterns?(module_name)
        reject_patterns.none? do |reject_pattern|
          module_name.match reject_pattern
        end
      end

      def reject_patterns
        @reject_patterns ||= Array value(REJECT_KEY, context)
      end

      def accept_patterns
        @accept_patterns ||= Array value(ACCEPT_KEY, context)
      end
    end
  end
end
