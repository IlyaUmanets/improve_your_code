# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      class HeadingFormatterBase
        attr_reader :report_formatter

        def initialize(report_formatter)
          @report_formatter = report_formatter
        end

        def show_header?(_examiner)
          raise NotImplementedError
        end

        def header(examiner)
          if show_header?(examiner)
            report_formatter.header examiner
          else
            ''
          end
        end
      end

      class VerboseHeadingFormatter < HeadingFormatterBase
        def show_header?(_examiner)
          true
        end
      end

      class QuietHeadingFormatter < HeadingFormatterBase
        def show_header?(examiner)
          examiner.smelly?
        end
      end
    end
  end
end
