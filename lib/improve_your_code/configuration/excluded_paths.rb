# frozen_string_literal: true

require_relative './configuration_validator'

module ImproveYourCode
  module Configuration
    module ExcludedPaths
      include ConfigurationValidator

      def add(paths)
        paths.each do |path|
          with_valid_directory(path) { |directory| self << directory }
        end
      end
    end
  end
end
