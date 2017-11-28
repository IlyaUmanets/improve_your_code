# frozen_string_literal: true

require_relative 'attribute_context'

module ImproveYourCode
  module Context
    class SingletonAttributeContext < AttributeContext
      def instance_method?
        false
      end
    end
  end
end
