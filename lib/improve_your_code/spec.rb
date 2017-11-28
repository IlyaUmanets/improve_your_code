# frozen_string_literal: true

require_relative 'spec/should_improve_your_code'
require_relative 'spec/should_improve_your_code_of'
require_relative 'spec/should_improve_your_code_only_of'

module ImproveYourCode
  module Spec
    def improve_your_code_of(smell_type,
                smell_details = {},
                configuration = Configuration::AppConfiguration.default)
      ShouldImproveYourCodeOf.new(smell_type, smell_details, configuration)
    end

    def improve_your_code_only_of(smell_type, configuration = Configuration::AppConfiguration.default)
      ShouldImproveYourCodeOnlyOf.new(smell_type, configuration)
    end

    def improve_your_code(configuration = Configuration::AppConfiguration.from_path)
      ShouldImproveYourCode.new(configuration: configuration)
    end
  end
end

if Object.const_defined?(:Spec)
  Spec::Runner.configure do |config|
    config.include(ImproveYourCode::Spec)
  end
end

if Object.const_defined?(:RSpec)
  RSpec.configure do |config|
    config.include(ImproveYourCode::Spec)
  end
end
