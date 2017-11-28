# frozen_string_literal: true

module ImproveYourCode
  class SmellConfiguration
    ENABLED_KEY = 'enabled'.freeze
    OVERRIDES_KEY = 'overrides'.freeze

    def initialize(hash)
      @options = hash
    end

    def merge(new_options)
      options.merge!(new_options)
    end

    def enabled?
      options[ENABLED_KEY]
    end

    def overrides_for(context)
      Overrides.new(options.fetch(OVERRIDES_KEY, {})).for_context(context)
    end

    def value(key, context)
      overrides_for(context).each { |conf| return conf[key] if conf.key?(key) }
      options.fetch(key)
    end

    private

    attr_reader :options
  end

  class Overrides
    def initialize(hash)
      @hash = hash
    end

    def for_context(context)
      contexts = hash.keys.select { |ckey| context.matches?([ckey]) }
      contexts.map { |exc| hash[exc] }
    end

    private

    attr_reader :hash
  end
end
