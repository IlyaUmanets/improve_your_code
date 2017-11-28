# frozen_string_literal: true

require_relative 'code_context'
require_relative 'method_context'

module ImproveYourCode
  module Context
    class RootContext < CodeContext
      def type
        :root
      end

      def full_name
        ''
      end

      def method_context_class
        MethodContext
      end
    end
  end
end
