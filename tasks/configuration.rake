require_relative '../lib/improve_your_code/detector_repository'
require 'yaml'

namespace :configuration do
  desc 'Updates the default configuration file when smell defaults change'
  task :update_default_configuration do
    DEFAULT_SMELL_CONFIGURATION = 'defaults.improve_your_code'.freeze
    content = ImproveYourCode::DetectorRepository.smell_types.each_with_object({}) do |klass, hash|
      hash[klass.smell_type] = klass.default_config
    end
    File.open(DEFAULT_SMELL_CONFIGURATION, 'w') { |file| YAML.dump(content, file) }
  end
end

task 'test:spec' => 'configuration:update_default_configuration'
