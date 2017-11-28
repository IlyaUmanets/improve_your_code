# frozen_string_literal: true

module ImproveYourCode
  module Configuration
    module DefaultDirective
      include ConfigurationValidator

      def add(key, config)
        detector = key_to_smell_detector(key)
        self[detector] = (self[detector] || {}).merge config
      end
    end
  end
end
