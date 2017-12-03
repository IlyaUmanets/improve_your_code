# frozen_string_literal: true

require_relative '../../examiner'
require_relative '../../report/text_report'

module ImproveYourCode
  module CLI
    module Command
      class ReportCommand
        def initialize(sources:)
          @sources = sources
        end

        def execute
          populate_reporter_with_smells
          reporter.show
        end

        private

        attr_reader :sources

        def smell_names
          @smell_names ||= []
        end

        def populate_reporter_with_smells
          sources.each do |source|
            reporter.add_examiner Examiner.new(source)
          end
        end

        def reporter
          @reporter ||= Report::TextReport.new
        end
      end
    end
  end
end
