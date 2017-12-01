# frozen_string_literal: true

require_relative 'report/text_report'
require_relative 'report/formatter'

module ImproveYourCode
  module Report
    def self.report_class
      TextReport
    end

    def self.location_formatter
      Formatter::DefaultLocationFormatter
    end

    def self.heading_formatter
      Formatter::QuietHeadingFormatter
    end

    def self.progress_formatter
      Formatter::ProgressFormatter::Dots
    end

    def self.warning_formatter_class
      Formatter::SimpleWarningFormatter
    end
  end
end
