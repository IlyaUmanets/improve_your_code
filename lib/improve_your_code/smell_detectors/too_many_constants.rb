# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class TooManyConstants < BaseDetector
      MAX_ALLOWED_CONSTANTS_KEY = 'max_constants'.freeze
      DEFAULT_MAX_CONSTANTS = 5
      IGNORED_NODES = %i[module class].freeze

      def self.contexts
        %i[class module]
      end

      def self.default_config
        super.merge(
          MAX_ALLOWED_CONSTANTS_KEY => DEFAULT_MAX_CONSTANTS,
          EXCLUDE_KEY => []
        )
      end

      def sniff
        count = constants_count

        return [] if count <= max_allowed_constants

        build_smell_warning(count)
      end

      private

      def constants_count
        context.each_node(:casgn, IGNORED_NODES)
               .delete_if(&:defines_module?).length
      end

      def max_allowed_constants
        value(MAX_ALLOWED_CONSTANTS_KEY, context)
      end

      def build_smell_warning(count)
        [
          smell_warning(
            context: context,
            lines: [source_line],
            message: "has #{count} constants",
            parameters: { count: count }
          )
        ]
      end
    end
  end
end
