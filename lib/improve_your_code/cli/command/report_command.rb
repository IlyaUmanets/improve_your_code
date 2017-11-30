# frozen_string_literal: true

require_relative 'base_command'
require_relative '../../examiner'
require_relative '../../report'

module ImproveYourCode
  module CLI
    module Command
      class ReportCommand < BaseCommand
        def execute
          populate_reporter_with_smells
          reporter.show
          result_code
        end

        private

        def populate_reporter_with_smells
          sources.each do |source|
            reporter.add_examiner Examiner.new(source)
          end
        end

        def result_code
          reporter.smells? ? 2 : 0
        end

        def reporter
          @reporter ||=
            report_class.new(
              warning_formatter: warning_formatter,
              report_formatter: Report::Formatter,
              sort_by_issue_count: sort_by_issue_count,
              heading_formatter: heading_formatter,
              progress_formatter: progress_formatter.new(sources.length))
        end

        def report_class
          Report.report_class(:text)
        end

        def warning_formatter
          warning_formatter_class.new(location_formatter: location_formatter)
        end

        def warning_formatter_class
          Report.warning_formatter_class(:wiki_links)
        end

        def location_formatter
          Report.location_formatter(:numbers)
        end

        def heading_formatter
          Report.heading_formatter(:quiet)
        end

        def progress_formatter
          Report.progress_formatter(:dots)
        end

        def sort_by_issue_count
          false
        end
      end
    end
  end
end
