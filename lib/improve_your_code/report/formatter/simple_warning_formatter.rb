# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      class SimpleWarningFormatter
        def format(warning)
          "#{warning.lines.sort.inspect}:#{warning.base_message}"
        end
      end
    end
  end
end
