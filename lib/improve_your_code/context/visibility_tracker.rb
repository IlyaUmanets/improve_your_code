# frozen_string_literal: true

module ImproveYourCode
  module Context
    class VisibilityTracker
      VISIBILITY_MODIFIERS = [:private, :public, :protected, :module_function].freeze
      VISIBILITY_MAP = { public_class_method: :public, private_class_method: :private }.freeze

      def initialize
        @tracked_visibility = :public
      end

      def track_visibility(children:, visibility:, names:)
        return unless VISIBILITY_MODIFIERS.include? visibility
        if names.any?
          children.each do |child|
            child.visibility = visibility if names.include?(child.name)
          end
        else
          self.tracked_visibility = visibility
        end
      end

      def track_singleton_visibility(children:, visibility:, names:)
        return if names.empty?
        visibility = VISIBILITY_MAP[visibility]
        return unless visibility
        track_visibility children: children, visibility: visibility, names: names
      end

      def set_child_visibility(child)
        child.apply_current_visibility tracked_visibility
      end

      private

      attr_accessor :tracked_visibility
    end
  end
end
