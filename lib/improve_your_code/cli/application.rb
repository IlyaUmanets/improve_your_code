# frozen_string_literal: true

require_relative '../source/source_locator'
require_relative 'command/report_command'

module ImproveYourCode
  module CLI
    class Application
      def initialize
        @command = command_class.new(sources: sources)
      end

      def execute
        enable_rainbow
        command.execute
      end

      private

      attr_reader :command

      def enable_rainbow
        Rainbow.enabled = $stdout.tty?
      end

      def command_class
        Command::ReportCommand
      end

      def sources
        working_directory_as_source
      end

      def working_directory_as_source
        Source::SourceLocator.new(['.']).sources
      end
    end
  end
end
