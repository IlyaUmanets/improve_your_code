# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      module ProgressFormatter
        class Dots
          def progress(examiner)
            examiner.smelly? ? display_smelly : display_clean
          end

          private

          def display_clean
            Rainbow('.').color(:green)
          end

          def display_smelly
            Rainbow('W').color(:red)
          end
        end
      end
    end
  end
end
