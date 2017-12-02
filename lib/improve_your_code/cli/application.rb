# frozen_string_literal: true

require_relative '../source/source_locator'
require_relative 'command/report_command'

module ImproveYourCode
  module CLI
    class Application
      def execute
        enable_rainbow

        command = Command::ReportCommand.new(sources: sources)

        command.execute

        true
      end

      private

      attr_reader :command

      def enable_rainbow
        Rainbow.enabled = true
      end

      def sources
        Source::SourceLocator.new(['.']).sources
      end
    end
  end
end
