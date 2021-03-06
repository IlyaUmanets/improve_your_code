# frozen_string_literal: true

require_relative '../cli/silencer'

ImproveYourCode::CLI::Silencer.silently do
  require 'parser'
end

module ImproveYourCode
  module AST
    class Node < ::Parser::AST::Node
      def initialize(type, children = [], options = {})
        @comments = options.fetch(:comments, [])
        super
      end

      def full_comment
        comments.map(&:text).join("\n")
      end

      def leading_comment
        line = location.line
        comment_lines = comments.select do |comment|
          comment.location.line < line
        end
        comment_lines.map(&:text).join("\n")
      end

      def line
        loc&.line
      end

      def each_node(target_type, ignoring = [], &blk)
        if block_given?
          look_for_type(target_type, ignoring, &blk)
        else
          result = []
          look_for_type(target_type, ignoring) { |exp| result << exp }
          result
        end
      end

      def find_nodes(target_types, ignoring = [])
        result = []
        look_for_types(target_types, ignoring) { |exp| result << exp }
        result
      end

      def contains_nested_node?(target_type)
        look_for_type(target_type) { |_elem| return true }
        false
      end

      def format_to_ruby
        if location
          lines = location.expression.source.split("\n").map(&:strip)
          lines.first
        else
          to_s
        end
      end

      def length
        1
      end

      def statements
        [self]
      end

      def source
        loc.expression.source_buffer.name
      end

      protected

      def look_for_type(target_type, ignoring = [], &blk)
        each_sexp do |elem|
          elem.look_for_type(target_type, ignoring, &blk) unless ignoring.include?(elem.type)
        end
        yield self if type == target_type
      end

      def look_for_types(target_types, ignoring = [], &blk)
        return if ignoring.include?(type)
        if target_types.include? type
          yield self
        else
          each_sexp do |elem|
            elem.look_for_types(target_types, ignoring, &blk)
          end
        end
      end

      private

      attr_reader :comments

      def each_sexp
        children.each { |elem| yield elem if elem.is_a? ::Parser::AST::Node }
      end
    end
  end
end
