require_relative '../../spec_helper'
require_lib 'improve_your_code/configuration/default_directive'

RSpec.describe ImproveYourCode::Configuration::DefaultDirective do
  describe '#add' do
    let(:directives) { {}.extend(described_class) }

    it 'adds a smell configuration' do
      directives.add :UncommunicativeVariableName, enabled: false
      expect(directives).to eq(ImproveYourCode::SmellDetectors::UncommunicativeVariableName => { enabled: false })
    end
  end
end
