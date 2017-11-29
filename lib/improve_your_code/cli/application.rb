# frozen_string_literal: true

require_relative 'options'
require_relative 'status'
require_relative '../configuration/app_configuration'
require_relative '../source/source_locator'
require_relative 'command/report_command'

module ImproveYourCode
  module CLI
    class Application
      attr_reader :configuration

      def initialize(argv)
        @options = configure_options(argv)
        @configuration = configure_app_configuration(options.config_file)
        @command = command_class.new(options: options,
                                     sources: sources,
                                     configuration: configuration)
      end

      def execute
        command.execute
      end

      private

      attr_reader :command, :options

      def configure_options(argv)
        Options.new(argv).parse
      end

      def configure_app_configuration(config_file)
        Configuration::AppConfiguration.from_path(config_file)
      end

      def command_class
        Command::ReportCommand
      end

      def sources
        if no_source_files_given?
          if input_was_piped?
            disable_progress_output_unless_verbose
            source_from_pipe
          else
            working_directory_as_source
          end
        else
          sources_from_argv
        end
      end

      def argv
        options.argv
      end

      def input_was_piped?
        !$stdin.tty?
      end

      def no_source_files_given?
        argv.empty?
      end

      def working_directory_as_source
        Source::SourceLocator.new(['.'], configuration: configuration, options: options).sources
      end

      def sources_from_argv
        Source::SourceLocator.new(argv, configuration: configuration, options: options).sources
      end

      def source_from_pipe
        [$stdin]
      end

      def disable_progress_output_unless_verbose
        options.progress_format = :quiet unless options.show_empty
      end
    end
  end
end
