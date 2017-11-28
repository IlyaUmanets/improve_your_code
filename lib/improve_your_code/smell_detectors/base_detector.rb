# frozen_string_literal: true

require 'set'
require_relative '../smell_warning'
require_relative '../smell_configuration'

module ImproveYourCode
  module SmellDetectors
    class BaseDetector
      attr_reader :config
      EXCLUDE_KEY = 'exclude'.freeze
      DEFAULT_EXCLUDE_SET = [].freeze

      def initialize(configuration: {}, context: nil)
        @config = SmellConfiguration.new(
          self.class.default_config.merge(configuration)
        )

        @context = context
      end

      def smell_type
        self.class.smell_type
      end

      def run
        return [] unless enabled?
        return [] if exception?

        sniff
      end

      def self.todo_configuration_for(smells)
        default_exclusions = default_config.fetch 'exclude'
        exclusions = default_exclusions + smells.map(&:context)
        { smell_type => { 'exclude' => exclusions.uniq } }
      end

      private

      attr_reader :context

      def expression
        @expression ||= context.exp
      end

      def source_line
        @line ||= expression.line
      end

      def exception?
        context.matches?(value(EXCLUDE_KEY, context))
      end

      def enabled?
        config.enabled? && config_for(context)[SmellConfiguration::ENABLED_KEY] != false
      end

      def value(key, ctx)
        config_for(ctx)[key] || config.value(key, ctx)
      end

      def config_for(ctx)
        ctx.config_for(self.class)
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

      class << self
        def smell_type
          @smell_type ||= name.split(/::/).last
        end

        def contexts
          [:def, :defs]
        end

        def default_config
          {
            SmellConfiguration::ENABLED_KEY => true,
            EXCLUDE_KEY => DEFAULT_EXCLUDE_SET.dup
          }
        end

        def inherited(subclass)
          descendants << subclass
        end

        def descendants
          @descendants ||= []
        end

        def valid_detector?(detector)
          descendants.map { |descendant| descendant.to_s.split('::').last }.
            include?(detector)
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
