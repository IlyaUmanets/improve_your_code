# frozen_string_literal: true

require_relative 'report/code_climate'
require_relative 'report/text_report'
require_relative 'report/formatter'

module ImproveYourCode
  module Report
    REPORT_CLASSES = {
      text: TextReport,
      code_climate: CodeClimateReport
    }.freeze

    LOCATION_FORMATTERS = {
      single_line: Formatter::SingleLineLocationFormatter,
      plain: Formatter::BlankLocationFormatter,
      numbers: Formatter::DefaultLocationFormatter
    }.freeze

    HEADING_FORMATTERS = {
      verbose: Formatter::VerboseHeadingFormatter,
      quiet: Formatter::QuietHeadingFormatter
    }.freeze

    PROGRESS_FORMATTERS = {
      dots: Formatter::ProgressFormatter::Dots,
      quiet: Formatter::ProgressFormatter::Quiet
    }.freeze

    WARNING_FORMATTER_CLASSES = {
      wiki_links: Formatter::WikiLinkWarningFormatter,
      simple: Formatter::SimpleWarningFormatter
    }.freeze

    def self.report_class(report_format)
      REPORT_CLASSES.fetch(report_format)
    end

    def self.location_formatter(location_format)
      LOCATION_FORMATTERS.fetch(location_format)
    end

    def self.heading_formatter(heading_format)
      HEADING_FORMATTERS.fetch(heading_format)
    end

    def self.progress_formatter(progress_format)
      PROGRESS_FORMATTERS.fetch(progress_format)
    end

    def self.warning_formatter_class(warning_format)
      WARNING_FORMATTER_CLASSES.fetch(warning_format)
    end
  end
end
