# frozen_string_literal: true

module ImproveYourCode
  module AST
    class ObjectRefs
      def initialize
        @refs = Hash.new { |refs, name| refs[name] = [] }
      end

      def record_reference(name:, line: nil)
        refs[name] << line
      end

      def most_popular
        max = refs.values.map(&:size).max
        refs.select { |_name, refs| refs.size == max }
      end

      def references_to(name)
        refs[name]
      end

      def self_is_max?
        refs.empty? || most_popular.keys.include?(:self)
      end

      private

      attr_reader :refs
    end
  end
end
