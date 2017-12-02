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

      klass_map.klass_for(type).new(type, children, location: sexp.loc, comments: comments)
    end

    private

    attr_reader :klass_map
  end
end


['const',
'class',
'module',
'args',
'cbase',
'sym',
'send',
'pair',
'hash',
'lvasgn',
'lvar',
'begin',
'def',
'str',
'optarg',
'arg',
'return',
'and',
'if',
'array',
'casgn',
'block',
'int',
'self',
'true',
'false',
'dstr',
'block_pass',
'kwarg',
'resbody',
'rescue',
'sclass',
'nil',
'ivasgn',
'or_asgn',
'regopt',
'regexp',
'csend',
'kwbegin',
'or',
'kwoptarg',
'splat',
'float',
'op_asgn',
'kwsplat',
'defs'
]
