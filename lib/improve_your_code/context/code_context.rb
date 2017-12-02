# frozen_string_literal: true

require_relative '../code_comment'
require_relative '../ast/object_refs'
require_relative 'statement_counter'

require 'forwardable'

module ImproveYourCode
  module Context
    class CodeContext
      include Enumerable
      extend Forwardable
      delegate each_node: :exp
      delegate %i[name type] => :exp

      attr_reader :children, :parent, :exp, :statement_counter

      def initialize(exp)
        @exp                = exp
        @children           = []
        @statement_counter  = StatementCounter.new
        @refs               = AST::ObjectRefs.new
      end

      def local_nodes(type, ignored = [], &blk)
        ignored += %i[casgn class module]
        each_node(type, ignored, &blk)
      end

      def each(&block)
        return enum_for(:each) unless block_given?

        yield self
        children.each do |child|
          child.each(&block)
        end
      end

      def register_with_parent(parent)
        @parent = parent.append_child_context(self) if parent
      end

      def append_child_context(child)
        children << child
        self
      end

      def record_call_to(exp)
        receiver = exp.receiver
        type = receiver ? receiver.type : :self
        line = exp.line
        case type
        when :lvar, :lvasgn
          unless exp.object_creation_call?
            refs.record_reference(name: receiver.name, line: line)
          end
        when :self
          refs.record_reference(name: :self, line: line)
        end
      end

      def record_use_of_self
        refs.record_reference(name: :self)
      end

      def matches?(candidates)
        my_fq_name = full_name
        candidates.any? do |candidate|
          candidate = Regexp.quote(candidate) if candidate.is_a?(String)
          /#{candidate}/ =~ my_fq_name
        end
      end

      def full_name
        exp.full_name('')
      end

      def config_for(detector_class)
        parent_config_for(detector_class).merge(
          configuration_via_code_commment[detector_class.smell_type] || {}
        )
      end

      def number_of_statements
        statement_counter.value
      end

      def singleton_method?
        false
      end

      def instance_method?
        false
      end

      def apply_current_visibility(_current_visibility); end

      private

      attr_reader :refs

      def configuration_via_code_commment
        @configuration_via_code_commment ||=
          CodeComment.new(
            comment: full_comment,
            line: exp.line,
            source: exp.source
          ).config
      end

      def full_comment
        exp.full_comment || ''
      end

      def parent_config_for(detector_class)
        parent ? parent.config_for(detector_class) : {}
      end
    end
  end
end
