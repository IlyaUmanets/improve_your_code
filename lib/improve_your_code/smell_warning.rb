# frozen_string_literal: true

require 'forwardable'

module ImproveYourCode
  class SmellWarning
    include Comparable
    extend Forwardable

    attr_reader :context, :lines, :message, :parameters, :smell_detector, :source
    def_delegators :smell_detector, :smell_type

    def initialize(smell_detector, context: '', lines:, message:,
                   source:, parameters: {})
      @smell_detector = smell_detector
      @source         = source
      @context        = context.to_s
      @lines          = lines
      @message        = message
      @parameters     = parameters

      freeze
    end

    def hash
      identifying_values.hash
    end

    def <=>(other)
      identifying_values <=> other.identifying_values
    end

    def eql?(other)
      (self <=> other).zero?
    end

    def to_hash
      stringified_params = Hash[parameters.map { |key, val| [key.to_s, val] }]
      base_hash.merge(stringified_params)
    end

    alias yaml_hash to_hash

    def base_message
      "#{smell_type}: #{context} #{message}"
    end

    def smell_class
      smell_detector.class
    end

    protected

    def identifying_values
      [smell_type, context, message, lines]
    end

    private

    def base_hash
      {
        'context'        => context,
        'lines'          => lines,
        'message'        => message,
        'smell_type'     => smell_type,
        'source'         => source
      }
    end
  end
end
