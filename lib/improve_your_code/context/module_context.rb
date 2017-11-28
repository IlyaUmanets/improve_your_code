# frozen_string_literal: true

require_relative 'code_context'
require_relative 'attribute_context'
require_relative 'method_context'
require_relative 'visibility_tracker'

module ImproveYourCode
  module Context
    class ModuleContext < CodeContext
      attr_reader :visibility_tracker

      def initialize(exp)
        super
        @visibility_tracker = VisibilityTracker.new
      end

      def append_child_context(child)
        visibility_tracker.set_child_visibility(child)
        super
      end

      def method_context_class
        MethodContext
      end

      def attribute_context_class
        AttributeContext
      end

      def defined_instance_methods(visibility: :public)
        instance_method_children.select do |context|
          context.visibility == visibility
        end
      end

      def instance_method_calls
        instance_method_children.flat_map do |context|
          context.children.grep(SendContext)
        end
      end

      def node_instance_methods
        local_nodes(:def)
      end

      def descriptively_commented?
        CodeComment.new(comment: exp.leading_comment).descriptive?
      end

      def namespace_module?
        return false if exp.type == :casgn
        children = exp.direct_children
        children.any? && children.all? { |child| [:casgn, :class, :module].include? child.type }
      end

      def track_visibility(visibility, names)
        visibility_tracker.track_visibility children: instance_method_children,
                                            visibility: visibility,
                                            names: names
        visibility_tracker.track_singleton_visibility children: singleton_method_children,
                                                      visibility: visibility,
                                                      names: names
      end

      private

      def instance_method_children
        children.select(&:instance_method?)
      end

      def singleton_method_children
        children.select(&:singleton_method?)
      end
    end
  end
end
