# frozen_string_literal: true

require_relative 'base_detector'

module ImproveYourCode
  module SmellDetectors
    class LongParameterList < BaseDetector
      MAX_ALLOWED_PARAMS_KEY = 'max_params'.freeze
      DEFAULT_MAX_ALLOWED_PARAMS = 3

      def self.default_config
        super.merge(
          MAX_ALLOWED_PARAMS_KEY => DEFAULT_MAX_ALLOWED_PARAMS,
          SmellConfiguration::OVERRIDES_KEY => {
            'initialize' => { MAX_ALLOWED_PARAMS_KEY => 5 }
          })
      end

      def sniff
        count = expression.arg_names.length
        return [] if count <= max_allowed_params
        [smell_warning(
          context: context,
          lines: [source_line],
          message: "has #{count} parameters",
          parameters: { count: count })]
      end

      private

      def max_allowed_params
        value(MAX_ALLOWED_PARAMS_KEY, context)
      end
    end
  end
end
