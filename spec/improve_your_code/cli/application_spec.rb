require_relative '../../spec_helper'
require_lib 'improve_your_code/cli/application'

RSpec.describe ImproveYourCode::CLI::Application do
  describe '#initialize' do
    it 'exits with default error code on invalid options' do
      call = lambda do
        ImproveYourCode::CLI::Silencer.silently do
          described_class.new ['--foo']
        end
      end
      expect(call).to raise_error(SystemExit) do |error|
        expect(error.status).to eq ImproveYourCode::CLI::Status::DEFAULT_ERROR_EXIT_CODE
      end
    end
  end

  describe '#execute' do
    let(:path_excluded_in_configuration) do
      SAMPLES_PATH.join('source_with_exclude_paths/ignore_me/uncommunicative_method_name.rb')
    end
    let(:configuration) { test_configuration_for(CONFIG_PATH.join('with_excluded_paths.improve_your_code')) }
    let(:command) { instance_double 'ImproveYourCode::CLI::Command::ReportCommand' }
    let(:app) { described_class.new [] }

    before do
      allow(ImproveYourCode::CLI::Command::ReportCommand).to receive(:new).and_return command
      allow(command).to receive(:execute).and_return 'foo'
    end

    it "returns the command's result code" do
      expect(app.execute).to eq 'foo'
    end

    context 'when no source files given and input was piped' do
      before do
        allow_any_instance_of(IO).to receive(:tty?).and_return(false)
      end

      it 'uses source form pipe' do
        app.execute
        expect(ImproveYourCode::CLI::Command::ReportCommand).to have_received(:new).
          with(sources: [$stdin],
               configuration: ImproveYourCode::Configuration::AppConfiguration,
               options: ImproveYourCode::CLI::Options)
      end
    end

    context 'when no source files given and no input was piped' do
      before do
        allow_any_instance_of(IO).to receive(:tty?).and_return(true)
      end

      it 'uses working directory as source' do
        expected_sources = ImproveYourCode::Source::SourceLocator.new(['.']).sources
        app.execute
        expect(ImproveYourCode::CLI::Command::ReportCommand).to have_received(:new).
          with(sources: expected_sources,
               configuration: ImproveYourCode::Configuration::AppConfiguration,
               options: ImproveYourCode::CLI::Options)
      end

      context 'when source files are excluded through configuration' do
        let(:app) { described_class.new ['--config', 'some_file.improve_your_code'] }

        before do
          allow(ImproveYourCode::Configuration::AppConfiguration).
            to receive(:from_path).
            with(Pathname.new('some_file.improve_your_code')).
            and_return configuration
        end

        it 'uses configuration for excluded paths' do
          expected_sources = ImproveYourCode::Source::SourceLocator.
            new(['.'], configuration: configuration).sources
          expect(expected_sources).not_to include(path_excluded_in_configuration)

          app.execute

          expect(ImproveYourCode::CLI::Command::ReportCommand).to have_received(:new).
            with(sources: expected_sources,
                 configuration: configuration,
                 options: ImproveYourCode::CLI::Options)
        end
      end
    end

    context 'when source files given' do
      let(:app) { described_class.new ['.'] }

      it 'uses sources from argv' do
        expected_sources = ImproveYourCode::Source::SourceLocator.new(['.']).sources
        app.execute
        expect(ImproveYourCode::CLI::Command::ReportCommand).to have_received(:new).
          with(sources: expected_sources,
               configuration: ImproveYourCode::Configuration::AppConfiguration,
               options: ImproveYourCode::CLI::Options)
      end

      context 'when source files are excluded through configuration' do
        let(:app) { described_class.new ['--config', 'some_file.improve_your_code', '.'] }

        before do
          allow(ImproveYourCode::Configuration::AppConfiguration).
            to receive(:from_path).
            with(Pathname.new('some_file.improve_your_code')).
            and_return configuration
        end

        it 'uses configuration for excluded paths' do
          expected_sources = ImproveYourCode::Source::SourceLocator.
            new(['.'], configuration: configuration).sources
          expect(expected_sources).not_to include(path_excluded_in_configuration)

          app.execute

          expect(ImproveYourCode::CLI::Command::ReportCommand).to have_received(:new).
            with(sources: expected_sources,
                 configuration: configuration,
                 options: ImproveYourCode::CLI::Options)
        end
      end
    end
  end
end
