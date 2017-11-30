# frozen_string_literal: true

require_relative 'smell_detectors'
require_relative 'smell_detectors/base_detector'

module ImproveYourCode
  class DetectorRepository
    def self.smell_types
      ImproveYourCode::SmellDetectors::BaseDetector.descendants.sort_by(&:name)
    end

    def self.eligible_smell_types
      return smell_types
    end

    def initialize(smell_types: self.class.smell_types)
      @smell_types   = smell_types
    end

    def examine(context)
      smell_detectors_for(context.type).flat_map do |klass|
        detector = klass.new context: context
        detector.run
      end
    end

    private

    attr_reader :smell_types

    def smell_detectors_for(type)
      smell_types.select { |detector| detector.contexts.include? type }
    end
  end
end
