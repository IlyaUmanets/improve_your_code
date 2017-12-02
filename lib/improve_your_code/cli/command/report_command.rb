# frozen_string_literal: true

require_relative 'base_command'
require_relative '../../examiner'
require_relative '../../report/text_report'
require_relative '../../report/formatter'

module ImproveYourCode
  module CLI
    module Command
      class ReportCommand < BaseCommand
        def execute
          populate_reporter_with_smells
          reporter.show
        end

        private

        def populate_reporter_with_smells
          sources.each do |source|
            reporter.add_examiner Examiner.new(source)
          end
        end

        def reporter
          @reporter ||=
            report_class.new(
              warning_formatter,
              progress_formatter.new
            )
        end

        def report_class
          Report::TextReport
        end

        def warning_formatter
          warning_formatter_class.new(location_formatter: location_formatter)
        end

        def warning_formatter_class
          Report::Formatter::SimpleWarningFormatter
        end

        def location_formatter
          Report::Formatter::DefaultLocationFormatter
        end

        def progress_formatter
          Report::Formatter::ProgressFormatter::Dots
        end
      end
    end
  end
end
