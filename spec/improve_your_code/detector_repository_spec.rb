require_relative '../spec_helper'
require_lib 'improve_your_code/smell_detectors/base_detector'
require_lib 'improve_your_code/detector_repository'

RSpec.describe ImproveYourCode::DetectorRepository do
  describe '.smell_types' do
    let(:smell_types) { described_class.smell_types }

    it 'includes existing smell_types' do
      expect(smell_types).to include(ImproveYourCode::SmellDetectors::IrresponsibleModule).
        and include(ImproveYourCode::SmellDetectors::TooManyStatements)
    end

    it 'excludes the smell detector base class' do
      expect(smell_types).not_to include(ImproveYourCode::SmellDetectors::BaseDetector)
    end

    it 'returns the smell types in alphabetic order' do
      expect(smell_types).to eq(smell_types.sort_by(&:name))
    end
  end
end
