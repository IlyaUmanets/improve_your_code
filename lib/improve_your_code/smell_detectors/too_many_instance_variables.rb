# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class TooManyInstanceVariables < BaseDetector
      MAX_ALLOWED_IVARS_KEY = 'max_instance_variables'
      DEFAULT_MAX_IVARS = 4

      def self.contexts
        [:class]
      end

      def self.default_config
        super.merge(
          MAX_ALLOWED_IVARS_KEY => DEFAULT_MAX_IVARS,
          EXCLUDE_KEY => []
        )
      end

      def sniff
        variables = context.local_nodes(:ivasgn, [:or_asgn]).map(&:name)
        count = variables.uniq.size

        return [] if count <= max_allowed_ivars

        [
          smell_warning(
            context: context,
            lines: [source_line],
            message: "has at least #{count} instance variables",
            parameters: { count: count }
          )
        ]
      end

      private

      def max_allowed_ivars
        value(MAX_ALLOWED_IVARS_KEY, context)
      end
    end
  end
end
