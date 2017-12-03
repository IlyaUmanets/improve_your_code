# frozen_string_literal: true

require_relative 'context_builder'
require_relative 'detector_repository'
require_relative 'source/source_code'

module ImproveYourCode
  class Examiner
    def initialize(source)
      @source = Source::SourceCode.from(source)
      @smell_types = DetectorRepository.eligible_smell_types
    end

    def description
      @description ||= source.origin
    end

    def smells
      @smells ||= examine_tree.sort.uniq
    end

    def smells_count
      smells.length
    end

    def smelly?
      smells.any?
    end

    private

    attr_reader :source

    def detector_repository
      DetectorRepository.new(smell_types: @smell_types)
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
