require_relative '../../spec_helper'
require_lib 'improve_your_code/configuration/excluded_paths'

RSpec.describe ImproveYourCode::Configuration::ExcludedPaths do
  describe '#add' do
    let(:exclusions) { [].extend(described_class) }

    context 'when one of given paths is a file' do
      let(:file_as_path) { SAMPLES_PATH.join('inline.rb') }
      let(:paths) { [SAMPLES_PATH, file_as_path] }

      it 'raises an error if one of the given paths is a file' do
        ImproveYourCode::CLI::Silencer.silently do
          expect { exclusions.add(paths) }.to raise_error(SystemExit)
        end
      end
    end
  end
end
