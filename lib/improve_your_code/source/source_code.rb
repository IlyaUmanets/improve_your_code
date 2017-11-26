# frozen_string_literal: true

require_relative '../cli/silencer'
ImproveYourCode::CLI::Silencer.silently do
  require 'parser/ruby24'
end
require_relative '../tree_dresser'
require_relative '../ast/node'
require_relative '../ast/builder'

# Opt in to new way of representing lambdas
ImproveYourCode::AST::Builder.emit_lambda = true

module ImproveYourCode
  module Source
    #
    # A +Source+ object represents a chunk of Ruby source code.
    #
    class SourceCode
      IO_IDENTIFIER     = 'STDIN'.freeze
      STRING_IDENTIFIER = 'string'.freeze

      attr_reader :origin

      # Initializer.
      #
      # code   - Ruby code as String
      # origin - 'STDIN', 'string' or a filepath as String
      # parser - the parser to use for generating AST's out of the given source
      def initialize(code:, origin:, parser: default_parser)
        @origin = origin
        @diagnostics = []
        @parser = parser
        @code = code
      end

      # Initializes an instance of SourceCode given a source.
      # This source can come via 4 different ways:
      # - from Files or Pathnames a la `improve_your_code lib/improve_your_code/`
      # - from IO (STDIN) a la `echo "class Foo; end" | improve_your_code`
      # - from String via our rspec matchers a la `expect("class Foo; end").to improve_your_code`
      #
      # @param source [File|IO|String] - the given source
      #
      # @return an instance of SourceCode
      # :improve_your_code:DuplicateMethodCall: { max_calls: 2 }
      def self.from(source)
        case source
        when File     then new(code: source.read,           origin: source.path)
        when IO       then new(code: source.readlines.join, origin: IO_IDENTIFIER)
        when Pathname then new(code: source.read,           origin: source.to_s)
        when String   then new(code: source,                origin: STRING_IDENTIFIER)
        end
      end

      # @return [true|false] Returns true if parsed file does not have any syntax errors.
      def valid_syntax?
        diagnostics.none? { |diagnostic| [:error, :fatal].include?(diagnostic.level) }
      end

      def diagnostics
        parse_if_needed
        @diagnostics
      end

      def syntax_tree
        parse_if_needed
      end

      private

      def parse_if_needed
        @syntax_tree ||= parse(@parser, @code)
      end

      attr_reader :source

      # Parses the given source into an AST and associates the source code comments with it.
      # This AST is then traversed by a TreeDresser which adorns the nodes in the AST
      # with our SexpExtensions.
      # Finally this AST is returned where each node is an anonymous subclass of ImproveYourCode::AST::Node
      #
      # Important to note is that ImproveYourCode will not fail on unparseable files but rather register a
      # parse error to @diagnostics and then just continue.
      #
      # Given this @source:
      #
      #   # comment about C
      #   class C
      #     def m
      #       puts 'nada'
      #     end
      #   end
      #
      # this method would return something that looks like
      #
      #   (class
      #     (const nil :C) nil
      #     (def :m
      #       (args)
      #       (send nil :puts
      #         (str "nada"))))
      #
      # where each node is possibly adorned with our SexpExtensions (see ast/ast_node_class_map
      # and ast/sexp_extensions for details).
      #
      # @param parser [Parser::Ruby24]
      # @param source [String] - Ruby code
      # @return [Anonymous subclass of ImproveYourCode::AST::Node] the AST presentation
      #         for the given source
      # :improve_your_code:TooManyStatements { max_statements: 6 }
      def parse(parser, source)
        buffer = Parser::Source::Buffer.new(origin, 1)
        source.force_encoding(Encoding::UTF_8)
        buffer.source = source
        ast, comments = parser.parse_with_comments(buffer)

        # See https://whitequark.github.io/parser/Parser/Source/Comment/Associator.html
        comment_map = Parser::Source::Comment.associate(ast, comments) if ast
        TreeDresser.new.dress(ast, comment_map)
      end

      # :improve_your_code:TooManyStatements: { max_statements: 6 }
      # :improve_your_code:FeatureEnvy
      def default_parser
        Parser::Ruby24.new(AST::Builder.new).tap do |parser|
          diagnostics = parser.diagnostics
          diagnostics.all_errors_are_fatal = false
          diagnostics.ignore_warnings      = false
          diagnostics.consumer = lambda do |diagnostic|
            @diagnostics << diagnostic
          end
        end
      end
    end
  end
end
