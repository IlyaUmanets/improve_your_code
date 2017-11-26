# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      # Utility methods for :super nodes.
      module SuperNode
        def name
          :super
        end
      end

      ZsuperNode = SuperNode
    end
  end
end
