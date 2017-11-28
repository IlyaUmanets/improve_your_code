# frozen_string_literal: true

module ImproveYourCode
  module AST
    class Builder < ::Parser::Builders::Default
      def string_value(token)
        value(token)
      end
    end
  end
end
