# frozen_string_literal: true

require 'set'
require_relative '../smell_warning'
require_relative '../smell_configuration'

module ImproveYourCode
  module SmellDetectors
    class BaseDetector
      attr_reader :config

      EXCLUDE_KEY = 'exclude'

      def initialize(context:)
        @config = SmellConfiguration.new(self.class.default_config)
        @context = context
      end

      def self.todo_configuration_for(smells)
        default_exclusions = default_config.fetch EXCLUDE_KEY
        exclusions = default_exclusions + smells.map(&:context)

        { smell_type => { EXCLUDE_KEY => exclusions.uniq } }
      end

      def run
        sniff
      end

      def smell_type
        self.class.smell_type
      end

      private

      attr_reader :context

      def config_for(ctx)
        ctx.config_for(self.class)
      end

      def enabled?
        config.enabled? && config_for(context)[
          SmellConfiguration::ENABLED_KEY
        ] != false
      end

      def exception?
        context.matches?(value(EXCLUDE_KEY, context))
      end

      def expression
        @expression ||= context.exp
      end

      def smell_warning(options = {})
        context = options.fetch(:context)
        exp = context.exp
        SmellWarning.new(self,
          source: exp.source,
          context: context.full_name,
          lines: options.fetch(:lines),
          message: options.fetch(:message),
          parameters: options.fetch(:parameters, {}))
      end

      def source_line
        @line ||= expression.line
      end

      def value(key, ctx)
        config_for(ctx)[key] || config.value(key, ctx)
      end

      class << self
        def smell_type
          @smell_type ||= name.split(/::/).last
        end

        def contexts
          %i[def defs]
        end

        def default_config
          {
            SmellConfiguration::ENABLED_KEY => true,
            EXCLUDE_KEY => []
          }
        end

        def inherited(subclass)
          descendants << subclass
        end

        def descendants
          @descendants ||= []
        end

        def valid_detector?(detector)
          descendants.map { |descendant| descendant.to_s.split('::').last }
            .include?(detector)
        end

        def to_detector(detector_name)
          SmellDetectors.const_get detector_name
        end

        def configuration_keys
          Set.new(default_config.keys.map(&:to_sym))
        end
      end
    end
  end
end
