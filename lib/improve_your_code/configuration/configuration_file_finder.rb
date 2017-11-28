# frozen_string_literal: true

require 'pathname'

module ImproveYourCode
  module Configuration
    class ConfigFileException < StandardError; end
    module ConfigurationFileFinder
      TOO_MANY_CONFIGURATION_FILES_MESSAGE = <<-MESSAGE.freeze

        Error: Found multiple configuration files %s
        while scanning directory %s.

        ImproveYourCode supports only one configuration file. You have 2 options now:
        1) Remove all offending files.
        2) Be specific about which one you want to load via the -c switch.

      MESSAGE

      class << self
        def find_and_load(path: nil)
          load_from_file(find(path: path))
        end

        def find(path: nil, current: Pathname.pwd, home: Pathname.new(Dir.home))
          path || find_by_dir(current) || find_in_dir(home)
        end

        def load_from_file(path)
          return {} unless path
          begin
            configuration = YAML.load_file(path) || {}
          rescue StandardError => error
            raise ConfigFileException, "Invalid configuration file #{path}, error is #{error}"
          end

          unless configuration.is_a? Hash
            raise ConfigFileException, "Invalid configuration file \"#{path}\" -- Not a hash"
          end
          configuration
        end

        private

        def find_by_dir(start)
          start.ascend do |dir|
            file = find_in_dir(dir)
            return file if file
          end
        end

        def find_in_dir(dir)
          found = dir.children.select { |item| item.file? && item.to_s.end_with?('.improve_your_code') }.sort
          if found.size > 1
            escalate_too_many_configuration_files found, dir
          else
            found.first
          end
        end

        def escalate_too_many_configuration_files(found, directory)
          offensive_files = found.map { |file| "'#{file.basename}'" }.join(', ')
          warn format(TOO_MANY_CONFIGURATION_FILES_MESSAGE, offensive_files, directory)
          exit 1
        end
      end
    end
  end
end
