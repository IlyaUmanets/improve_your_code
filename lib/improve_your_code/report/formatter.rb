# frozen_string_literal: true

require_relative 'formatter/heading_formatter'
require_relative 'formatter/progress_formatter'
require_relative 'formatter/simple_warning_formatter'

module ImproveYourCode
  module Report
    module Formatter
      module_function

      def format_list(warnings, formatter: SimpleWarningFormatter.new)
        warnings.map { |warning| "  #{formatter.format(warning)}" }.join("\n")
      end

      def header(examiner)
        count = examiner.smells_count
        result = Rainbow("#{examiner.description} -- ").cyan +
                 Rainbow("#{count} warning").yellow
        result += Rainbow('s').yellow unless count == 1
        result
      end
    end
  end
end
