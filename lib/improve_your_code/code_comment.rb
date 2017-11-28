# frozen_string_literal: true

require 'yaml'

require_relative 'smell_detectors/base_detector'
require_relative 'errors/bad_detector_in_comment_error'
require_relative 'errors/bad_detector_configuration_key_in_comment_error'
require_relative 'errors/garbage_detector_configuration_in_comment_error'

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
    DISABLE_DETECTOR_CONFIGURATION = '{ enabled: false }'.freeze
    MINIMUM_CONTENT_LENGTH         = 2
    LEGACY_SEPARATOR               = ':'.freeze

    attr_reader :config

    def initialize(comment:, line: nil, source: nil)
      @original_comment  = comment
      @line              = line
      @source            = source
      @config            = Hash.new { |hash, key| hash[key] = {} }

      @original_comment.scan(CONFIGURATION_REGEX) do |detector_name, _option_string, options|
        CodeCommentValidator.new(detector_name:    detector_name,
                                 original_comment: original_comment,
                                 line:             line,
                                 source:           source,
                                 options:          options).validate
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
      @sanitized_comment ||= original_comment.
        gsub(CONFIGURATION_REGEX, '').
        gsub(SANITIZE_REGEX, ' ').
        strip
    end

    class CodeCommentValidator
      def initialize(detector_name:, original_comment:, line:, source:, options: {})
        @detector_name    = detector_name
        @original_comment = original_comment
        @line             = line
        @source           = source
        @options          = options
        @detector_class   = nil
        @parsed_options   = nil
      end

      def validate
        escalate_bad_detector
        escalate_bad_detector_configuration
        escalate_unknown_configuration_key
      end

      private

      attr_reader :detector_name,
                  :original_comment,
                  :line,
                  :source,
                  :options,
                  :detector_class,
                  :parsed_options

      def escalate_bad_detector
        return if SmellDetectors::BaseDetector.valid_detector?(detector_name)
        raise Errors::BadDetectorInCommentError, detector_name: detector_name,
                                                 original_comment: original_comment,
                                                 source: source,
                                                 line: line
      end

      def escalate_bad_detector_configuration
        @parsed_options = YAML.safe_load(options || CodeComment::DISABLE_DETECTOR_CONFIGURATION,
                                         [Regexp])
      rescue Psych::SyntaxError
        raise Errors::GarbageDetectorConfigurationInCommentError, detector_name: detector_name,
                                                                  original_comment: original_comment,
                                                                  source: source,
                                                                  line: line
      end

      def escalate_unknown_configuration_key
        @detector_class = SmellDetectors::BaseDetector.to_detector(detector_name)

        return if given_keys_legit?
        raise Errors::BadDetectorConfigurationKeyInCommentError, detector_name: detector_name,
                                                                 offensive_keys: configuration_keys_difference,
                                                                 original_comment: original_comment,
                                                                 source: source,
                                                                 line: line
      end

      def given_keys_legit?
        given_configuration_keys.subset? valid_detector_keys
      end

      def given_configuration_keys
        parsed_options.keys.map(&:to_sym).to_set
      end

      def configuration_keys_difference
        given_configuration_keys.difference(valid_detector_keys).
          to_a.map { |key| "'#{key}'" }.
          join(', ')
      end

      def valid_detector_keys
        detector_class.configuration_keys
      end
    end
  end
end
