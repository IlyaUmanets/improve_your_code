# frozen_string_literal: true

require_relative 'context_builder'
require_relative 'detector_repository'
require_relative 'source/source_code'

module ImproveYourCode
  class Examiner
    class NullHandler
      def handle(_exception)
        false
      end
    end

    def initialize(source,
                   detector_repository_class: DetectorRepository,
                   error_handler: NullHandler.new)
      @source              = Source::SourceCode.from(source)
      @smell_types         = detector_repository_class.eligible_smell_types
      @detector_repository = detector_repository_class.new(smell_types: @smell_types)
      @error_handler       = error_handler
    end

    def origin
      @origin ||= source.origin
    end

    def description
      origin
    end

    def smells
      @smells ||= run.sort.uniq
    end

    def smells_count
      smells.length
    end

    def smelly?
      !smells.empty?
    end

    private

    attr_reader :source, :detector_repository

    def run
      if source.valid_syntax? && syntax_tree
        examine_tree
      else
        SmellDetectors::Syntax.smells_from_source(source)
      end
    end

    def syntax_tree
      @syntax_tree ||= source.syntax_tree
    end

    def examine_tree
      ContextBuilder.new(syntax_tree).context_tree.flat_map do |element|
        detector_repository.examine(element)
      end
    end
  end
end
