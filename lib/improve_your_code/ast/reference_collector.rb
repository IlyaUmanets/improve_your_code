# frozen_string_literal: true

module ImproveYourCode
  module AST
    class ReferenceCollector
      def initialize(ast)
        @ast = ast
      end

      def num_refs_to_self
        (explicit_self_calls + implicit_self_calls).size
      end

      private

      attr_reader :ast

      def explicit_self_calls
        %i[self super zsuper ivar ivasgn].flat_map do |node_type|
          ast.each_node(node_type)
        end
      end

      def implicit_self_calls
        ast.each_node(:send).reject(&:receiver)
      end
    end
  end
end
