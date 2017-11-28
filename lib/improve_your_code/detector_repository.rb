# frozen_string_literal: true

require_relative 'smell_detectors'
require_relative 'smell_detectors/base_detector'
require_relative 'configuration/app_configuration'

module ImproveYourCode
  class DetectorRepository
    def self.smell_types
      ImproveYourCode::SmellDetectors::BaseDetector.descendants.sort_by(&:name)
    end

    def self.eligible_smell_types(filter_by_smells = [])
      return smell_types if filter_by_smells.empty?
      smell_types.select do |klass|
        filter_by_smells.include? klass.smell_type
      end
    end

    def initialize(smell_types: self.class.smell_types,
                   configuration: {})
      @configuration = configuration
      @smell_types   = smell_types
    end

    def examine(context)
      smell_detectors_for(context.type).flat_map do |klass|
        detector = klass.new configuration: configuration_for(klass), context: context
        detector.run
      end
    end

    private

    attr_reader :configuration, :smell_types

    def configuration_for(klass)
      configuration.fetch klass, {}
    end

    def smell_detectors_for(type)
      smell_types.select { |detector| detector.contexts.include? type }
    end
  end
end
