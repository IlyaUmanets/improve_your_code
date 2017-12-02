# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      module NestedAssignables
        def components
          children.flat_map(&:components)
        end
      end

      module ArgsNode
        include NestedAssignables
      end
    end
  end
end
