# frozen_string_literal: true

require 'json'
require 'pathname'
require 'rainbow'

require_relative 'formatter'

module ImproveYourCode
  module Report
    class BaseReport
      NO_WARNINGS_COLOR = :green
      WARNINGS_COLOR = :red

      def initialize(heading_formatter: Formatter::QuietHeadingFormatter,
        warning_formatter: Formatter::SimpleWarningFormatter.new,
        progress_formatter: Formatter::ProgressFormatter::Quiet.new(0))
        @examiners           = []
        @report_formatter    = Formatter
        @heading_formatter   = heading_formatter.new(Formatter)
        @progress_formatter  = progress_formatter
        @sort_by_issue_count = false
        @total_smell_count   = 0
        @warning_formatter   = warning_formatter
      end

      def add_examiner(examiner)
        self.total_smell_count += examiner.smells_count
        examiners << examiner
        self
      end

      def show
        raise NotImplementedError
      end

      def smells?
        total_smell_count > 0
      end

      def smells
        examiners.map(&:smells).flatten
      end

      protected

      attr_accessor :total_smell_count

      private

      attr_reader :examiners, :heading_formatter, :report_formatter,
        :sort_by_issue_count, :warning_formatter, :progress_formatter
    end
  end
end
