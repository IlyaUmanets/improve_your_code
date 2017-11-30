# frozen_string_literal: true

module ImproveYourCode
  module CLI
    module Command
      #
      # Base class for all commands
      #
      class BaseCommand
        def initialize(sources:)
          @sources = sources
        end

        private

        attr_reader :sources

        def smell_names
          @smell_names ||= []
        end
      end
    end
  end
end
