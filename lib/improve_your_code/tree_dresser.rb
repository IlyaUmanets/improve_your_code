# frozen_string_literal: true

require_relative 'ast/ast_node_class_map'

module ImproveYourCode
  class TreeDresser
    def initialize(klass_map: AST::ASTNodeClassMap.new)
      @klass_map = klass_map
    end

    def dress(sexp, comment_map)
      return sexp unless sexp.is_a? ::Parser::AST::Node
      type = sexp.type
      children = sexp.children.map { |child| dress(child, comment_map) }
      comments = comment_map[sexp]
      klass_map.klass_for(type).new(type, children,
        location: sexp.loc, comments: comments)
    end

    private

    attr_reader :klass_map
  end
end
