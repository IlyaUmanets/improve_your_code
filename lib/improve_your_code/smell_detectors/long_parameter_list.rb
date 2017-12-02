# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class LongParameterList < BaseDetector
      MAX_ALLOWED_PARAMS_KEY = 'max_params'

      def self.default_config
        super.merge(
          MAX_ALLOWED_PARAMS_KEY => 3,
          SmellConfiguration::OVERRIDES_KEY => {
            'initialize' => { MAX_ALLOWED_PARAMS_KEY => 3 }
          }
        )
      end

      def sniff
        count = expression.arg_names.length

        return [] if count <= max_allowed_params

        message = "has #{count} parameters. "\
                  "We propose to use Builder Pattern."

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

      def max_allowed_params
        value(MAX_ALLOWED_PARAMS_KEY, context)
      end
    end
  end
end
