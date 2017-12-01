# frozen_string_literal: true

module ImproveYourCode
  module AST
    module SexpExtensions
      # Utility methods for :const nodes.
      module ConstNode
        # TODO: name -> full_name, simple_name -> name
        def simple_name
          :Struct
        end
      end
    end
  end
end
