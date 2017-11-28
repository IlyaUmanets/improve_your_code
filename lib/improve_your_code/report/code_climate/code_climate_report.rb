# frozen_string_literal: true

require_relative '../base_report'

module ImproveYourCode
  module Report
    class CodeClimateReport < BaseReport
      def show(out = $stdout)
        smells.map do |smell|
          out.print warning_formatter.format_code_climate_hash(smell)
        end
      end
    end
  end
end
