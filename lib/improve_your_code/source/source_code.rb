# frozen_string_literal: true

require_relative '../cli/silencer'
ImproveYourCode::CLI::Silencer.silently do
  require 'parser/ruby24'
end
require_relative '../tree_dresser'
require_relative '../ast/node'
require_relative '../ast/builder'

ImproveYourCode::AST::Builder.emit_lambda = true

module ImproveYourCode
  module Source
    class SourceCode
      IO_IDENTIFIER     = 'STDIN'.freeze
      STRING_IDENTIFIER = 'string'.freeze

      attr_reader :origin

      def initialize(code:, origin:, parser: default_parser)
        @origin = origin
        @diagnostics = []
        @parser = parser
        @code = code
      end

      def self.from(source)
        case source
        when File     then new(code: source.read,           origin: source.path)
        when IO       then new(code: source.readlines.join, origin: IO_IDENTIFIER)
        when Pathname then new(code: source.read,           origin: source.to_s)
        when String   then new(code: source,                origin: STRING_IDENTIFIER)
        end
      end

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

      def parse(parser, source)
        buffer = Parser::Source::Buffer.new(origin, 1)
        source.force_encoding(Encoding::UTF_8)
        buffer.source = source
        ast, comments = parser.parse_with_comments(buffer)

        comment_map = Parser::Source::Comment.associate(ast, comments) if ast
        TreeDresser.new.dress(ast, comment_map)
      end

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
