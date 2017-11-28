# frozen_string_literal: true

require_relative './configuration_validator'

module ImproveYourCode
  module Configuration
    module DirectoryDirectives
      include ConfigurationValidator

      def directive_for(source_via)
        return unless source_via
        source_base_dir = Pathname.new(source_via).dirname
        hit = best_match_for source_base_dir
        self[hit]
      end

      def add(path, config)
        with_valid_directory(path) do |directory|
          self[directory] = config.each_with_object({}) do |(key, value), hash|
            abort(error_message_for_invalid_smell_type(key)) unless smell_type?(key)
            hash[key_to_smell_detector(key)] = value
          end
        end
        self
      end

      private

      def best_match_for(source_base_dir)
        keys.
          select { |pathname| source_base_dir.to_s.match(/#{Regexp.escape(pathname.to_s)}/) }.
          max_by { |pathname| pathname.to_s.length }
      end

      def error_message_for_invalid_smell_type(klass)
        "You are trying to configure smell type #{klass} but we can't find one with that name.\n" \
          "Please make sure you spelled it right. (See 'defaults.improve_your_code' in the ImproveYourCode\n" \
          'repository for a list of all available smell types.)'
      end
    end
  end
end
