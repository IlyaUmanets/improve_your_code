# frozen_string_literal: true

require 'yaml'

require_relative 'smell_detectors/base_detector'

module ImproveYourCode
  class CodeComment
    CONFIGURATION_REGEX = /
                          :improve_your_code: # prefix
                          (\w+)  # smell detector e.g.: UncommunicativeVariableName
                          (
                            :? # legacy separator
                            \s*
                            (\{.*?\}) # optional details in hash style e.g.: { max_methods: 30 }
                          )?
                         /x
    SANITIZE_REGEX                 = /(#|\n|\s)+/ # Matches '#', newlines and > 1 whitespaces.
    DISABLE_DETECTOR_CONFIGURATION = '{ enabled: false }'
    MINIMUM_CONTENT_LENGTH         = 2
    LEGACY_SEPARATOR               = ':'

    attr_reader :config

    def initialize(comment:, line: nil, source: nil)
      @original_comment  = comment
      @line              = line
      @source            = source
      @config            = Hash.new { |hash, key| hash[key] = {} }

      @original_comment.scan(CONFIGURATION_REGEX) do |detector_name, _option_string, options|
        @config.merge! detector_name => YAML.safe_load(options || DISABLE_DETECTOR_CONFIGURATION,
          [Regexp])
      end
    end

    def descriptive?
      sanitized_comment.split(/\s+/).length >= MINIMUM_CONTENT_LENGTH
    end

    private

    attr_reader :original_comment, :source, :line

    def sanitized_comment
      @sanitized_comment ||= original_comment
        .gsub(CONFIGURATION_REGEX, '')
        .gsub(SANITIZE_REGEX, ' ')
        .strip
    end
  end
end
