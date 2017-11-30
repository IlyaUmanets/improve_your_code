# frozen_string_literal: true

require 'find'
require 'pathname'

module ImproveYourCode
  module Source
    class SourceLocator
      def initialize(paths)
        @paths = paths.flat_map { |string| Pathname.new(string).entries }
      end

      def sources
        paths.each_with_object([]) do |given_path, relevant_paths|
          given_path.find do |path|
            if path.directory?
              ignore_path?(path) ? Find.prune : next
            elsif ruby_file?(path)
              relevant_paths << path
            end
          end
        end
      end

      private

      attr_reader :paths

      def ignore_path?(path)
        path.basename.to_s.start_with? '.'
      end

      def ruby_file?(path)
        path.extname == '.rb'
      end
    end
  end
end
