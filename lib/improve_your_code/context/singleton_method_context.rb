# frozen_string_literal: true

require_relative 'method_context'

module ImproveYourCode
  module Context
    class SingletonMethodContext < MethodContext
      def singleton_method?
        true
      end

      def instance_method?
        false
      end

      def module_function?
        false
      end

      def defined_as_instance_method?
        type == :def
      end

      def apply_current_visibility(current_visibility)
        super if defined_as_instance_method?
      end
    end
  end
end
