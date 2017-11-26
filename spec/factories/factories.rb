require_relative '../../lib/improve_your_code/smell_detectors'
require_relative '../../lib/improve_your_code/smell_detectors/base_detector'
require_relative '../../lib/improve_your_code/smell_warning'
require_relative '../../lib/improve_your_code/cli/options'

FactoryBot.define do
  factory :smell_detector, class: ImproveYourCode::SmellDetectors::BaseDetector do
    skip_create
    transient do
      smell_type 'FeatureEnvy'
    end

    initialize_with do
      ::ImproveYourCode::SmellDetectors.const_get(smell_type).new
    end
  end

  factory :smell_warning, class: ImproveYourCode::SmellWarning do
    skip_create
    smell_detector
    context 'self'
    source 'dummy_file'
    lines [42]
    message 'smell warning message'
    parameters { {} }

    initialize_with do
      new(smell_detector,
          source: source,
          context: context,
          lines: lines,
          message: message,
          parameters: parameters)
    end
  end

  factory :code_comment, class: ImproveYourCode::CodeComment do
    comment ''
    line 1
    source 'string'
    initialize_with do
      new comment: comment,
          line: line,
          source: source
    end
  end
end
