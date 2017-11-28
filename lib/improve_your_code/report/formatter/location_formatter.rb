# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      module BlankLocationFormatter
        module_function

        def format(_warning)
          ''
        end
      end

      module DefaultLocationFormatter
        module_function

        def format(warning)
          "#{warning.lines.sort.inspect}:"
        end
      end

      module SingleLineLocationFormatter
        module_function

        def format(warning)
          "#{warning.source}:#{warning.lines.sort.first}: "
        end
      end
    end
  end
end
