# frozen_string_literal: true

require 'json'
require 'pathname'
require 'rainbow'

require_relative 'formatter'

module ImproveYourCode
  module Report
    class TextReport
      NO_WARNINGS_COLOR = :green
      WARNINGS_COLOR = :red

      def initialize
        @examiners           = []
        @total_smell_count   = 0
        @heading_formatter   = Formatter::QuietHeadingFormatter.new(Formatter)
        @progress_formatter  = Report::Formatter::ProgressFormatter::Dots.new
        @warning_formatter   = Report::Formatter::SimpleWarningFormatter.new
      end

      def add_examiner(examiner)
        print progress_formatter.progress examiner
        
        self.total_smell_count += examiner.smells_count

        examiners << examiner
      end

      def show
        print "\n\n"

        display_summary

        print total_smell_count_message
      end

      protected

      attr_accessor :total_smell_count

      private

      attr_reader :examiners, :heading_formatter,
        :warning_formatter, :progress_formatter

      def smell_summaries
        examiners.map { |ex| summarize_single_examiner(ex) }.reject(&:empty?)
      end

      def display_summary
        smell_summaries.each { |smell| puts smell }
      end

      def summarize_single_examiner(examiner)
        result = heading_formatter.header(examiner)
        if examiner.smelly?
          formatted_list = Formatter.format_list(examiner.smells,
            formatter: warning_formatter)
          result += ":\n#{formatted_list}"
        end
        result
      end

      def smells?
        total_smell_count > 0
      end

      def total_smell_count_message
        colour = smells? ? WARNINGS_COLOR : NO_WARNINGS_COLOR
        Rainbow("#{total_smell_count} total warning#{total_smell_count == 1 ? '' : 's'}\n").color(colour)
      end
    end
  end
end
