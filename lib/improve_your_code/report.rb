# frozen_string_literal: true

require_relative 'report/text_report'
require_relative 'report/formatter'

module ImproveYourCode
  module Report
    def self.report_class(report_format)
      TextReport
    end

    def self.location_formatter(location_format)
      Formatter::DefaultLocationFormatter
    end

    def self.heading_formatter(heading_format)
      Formatter::QuietHeadingFormatter
    end

    def self.progress_formatter(progress_format)
      Formatter::ProgressFormatter::Dots
    end

    def self.warning_formatter_class(warning_format)
      Formatter::WikiLinkWarningFormatter
    end
  end
end
