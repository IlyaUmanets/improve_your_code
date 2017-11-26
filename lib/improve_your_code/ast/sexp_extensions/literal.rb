# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      # Utility methods for :lit nodes.
      module LitNode
        def value
          children.first
        end
      end
    end
  end
end
