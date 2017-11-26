# frozen_string_literal: true

require_relative '../examiner'
require_relative '../report/formatter'
require_relative 'should_improve_your_code_of'
require_relative 'smell_matcher'

module ImproveYourCode
  module Spec
    #
    # An rspec matcher that matches when the +actual+ has the specified
    # code smell and no others.
    #
    class ShouldImproveYourCodeOnlyOf < ShouldImproveYourCodeOf
      def matches?(source)
        matches_examiner?(Examiner.new(source, configuration: configuration))
      end

      def matches_examiner?(examiner)
        self.examiner = examiner
        self.warnings = examiner.smells
        return false if warnings.empty?
        warnings.all? { |warning| SmellMatcher.new(warning).matches?(smell_type) }
      end

      def failure_message
        rpt = Report::Formatter.format_list(warnings)
        "Expected #{examiner.description} to improve_your_code only of #{smell_type}, but got:\n#{rpt}"
      end

      def failure_message_when_negated
        "Expected #{examiner.description} not to improve_your_code only of #{smell_type}, but it did"
      end

      private

      attr_accessor :warnings
    end
  end
end
