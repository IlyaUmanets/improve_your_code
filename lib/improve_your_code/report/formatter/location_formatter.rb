# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      module DefaultLocationFormatter
        module_function

        def format(warning)
          "#{warning.lines.sort.inspect}:"
        end
      end
    end
  end
end
