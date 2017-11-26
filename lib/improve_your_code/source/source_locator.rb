# frozen_string_literal: true

require 'find'
require 'pathname'

module ImproveYourCode
  module Source
    #
    # Finds Ruby source files in a filesystem.
    #
    class SourceLocator
      # Initialize with the paths we want to search.
      #
      # paths - a list of paths as Strings
      def initialize(paths, configuration: Configuration::AppConfiguration.default, options: ImproveYourCode::CLI::Options.new)
        @options = options
        @paths = paths.flat_map do |string|
          path = Pathname.new(string)
          current_directory?(path) ? path.entries : path
        end
        @configuration = configuration
      end

      # Traverses all paths we initialized the SourceLocator with, finds
      # all relevant Ruby files and returns them as a list.
      #
      # @return [Array<Pathname>] - Ruby paths found
      def sources
        source_paths
      end

      private

      attr_reader :configuration, :paths, :options

      # :improve_your_code:TooManyStatements: { max_statements: 7 }
      # :improve_your_code:NestedIterators: { max_allowed_nesting: 2 }
      def source_paths
        paths.each_with_object([]) do |given_path, relevant_paths|
          unless given_path.exist?
            print_no_such_file_error(given_path)
            next
          end

          given_path.find do |path|
            if path.directory?
              ignore_path?(path) ? Find.prune : next
            elsif ruby_file?(path)
              relevant_paths << path unless ignore_file?(path)
            end
          end
        end
      end

      def ignore_file?(path)
        if options.force_exclusion?
          path.ascend do |ascendant|
            break true if path_excluded?(ascendant)
            false
          end
        else
          false
        end
      end

      def path_excluded?(path)
        configuration.path_excluded?(path)
      end

      # :improve_your_code:UtilityFunction
      def print_no_such_file_error(path)
        warn "Error: No such file - #{path}"
      end

      # :improve_your_code:UtilityFunction
      def hidden_directory?(path)
        path.basename.to_s.start_with? '.'
      end

      def ignore_path?(path)
        path_excluded?(path) || hidden_directory?(path)
      end

      # :improve_your_code:UtilityFunction
      def ruby_file?(path)
        path.extname == '.rb'
      end

      # :improve_your_code:UtilityFunction
      def current_directory?(path)
        [Pathname.new('.'), Pathname.new('./')].include?(path)
      end
    end
  end
end
