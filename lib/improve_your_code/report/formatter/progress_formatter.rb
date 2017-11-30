# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      module ProgressFormatter
        class Base
          attr_reader :sources_count

          def initialize(sources_count)
            @sources_count = sources_count
          end

          def header
            raise NotImplementedError
          end

          def progress(_examiner)
            raise NotImplementedError
          end

          def footer
            raise NotImplementedError
          end
        end

        class Dots < Base
          NO_WARNINGS_COLOR = :green
          WARNINGS_COLOR = :red

          def header
            "Inspecting #{sources_count} file(s):\n"
          end

          def progress(examiner)
            examiner.smelly? ? display_smelly : display_clean
          end

          def footer
            "\n\n"
          end

          private

          def display_clean
            Rainbow('.').color(NO_WARNINGS_COLOR)
          end

          def display_smelly
            Rainbow('S').color(WARNINGS_COLOR)
          end
        end
      end
    end
  end
end
