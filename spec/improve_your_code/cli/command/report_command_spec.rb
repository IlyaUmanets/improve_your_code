require_relative '../../../spec_helper'
require_lib 'improve_your_code/cli/command/report_command'
require_lib 'improve_your_code/cli/options'

RSpec.describe ImproveYourCode::CLI::Command::ReportCommand do
  describe '#execute' do
    let(:options) { ImproveYourCode::CLI::Options.new [] }

    let(:configuration) { instance_double 'ImproveYourCode::Configuration::AppConfiguration' }
    let(:sources) { [source_file] }

    let(:command) do
      described_class.new(options: options,
                          sources: sources,
                          configuration: configuration)
    end

    before do
      allow(configuration).to receive(:directive_for).and_return({})
    end

    context 'when no smells are found' do
      let(:source_file) { CLEAN_FILE }

      it 'returns a success code' do
        result = ImproveYourCode::CLI::Silencer.silently do
          command.execute
        end
        expect(result).to eq ImproveYourCode::CLI::Status::DEFAULT_SUCCESS_EXIT_CODE
      end
    end

    context 'when smells are found' do
      let(:source_file) { SMELLY_FILE }

      it 'returns a failure code' do
        result = ImproveYourCode::CLI::Silencer.silently do
          command.execute
        end
        expect(result).to eq ImproveYourCode::CLI::Status::DEFAULT_FAILURE_EXIT_CODE
      end
    end
  end
end
