# frozen_string_literal: true

module ImproveYourCode
  module Report
    module Formatter
      class SimpleWarningFormatter
        def initialize(location_formatter: BlankLocationFormatter)
          @location_formatter = location_formatter
        end

        def format(warning)
          "#{location_formatter.format(warning)}#{warning.base_message}"
        end

        def format_hash(warning)
          warning.yaml_hash
        end

        def format_code_climate_hash(warning)
          CodeClimateFormatter.new(warning).render
        end

        private

        attr_reader :location_formatter
      end
    end
  end
end
