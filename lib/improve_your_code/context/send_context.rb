# frozen_string_literal: true

require_relative 'code_context'

module ImproveYourCode
  module Context
    class SendContext < CodeContext
      attr_reader :name

      def initialize(exp, name)
        @name = name
        super exp
      end
    end
  end
end
