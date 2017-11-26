# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      # Utility methods for :lambda nodes.
      module LambdaNode
        def name
          'lambda'
        end
      end
    end
  end
end
