# frozen_string_literal: true

require_relative '../ast/node'

module ImproveYourCode
  module Context
    class StatementCounter
      attr_reader :value

      def initialize
        @value = 0
      end

      def increase_by(sexp)
        self.value = value + sexp.length if sexp
      end

      def decrease_by(number)
        self.value = value - number
      end

      private

      attr_writer :value
    end
  end
end
