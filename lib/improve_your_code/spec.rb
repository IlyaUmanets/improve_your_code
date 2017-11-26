# frozen_string_literal: true

require_relative 'spec/should_improve_your_code'
require_relative 'spec/should_improve_your_code_of'
require_relative 'spec/should_improve_your_code_only_of'

module ImproveYourCode
  #
  # Provides matchers for Rspec, making it easy to check code quality.
  #
  # If you require this module somewhere within your spec (or in your spec_helper),
  # ImproveYourCode will arrange to update Spec::Runner's config so that it knows about the
  # matchers defined here.
  #
  # === Examples
  #
  # Here's a spec that ensures there are no active code smells in the current project:
  #
  #  describe 'source code quality' do
  #    Pathname.glob('lib/**/*.rb').each do |path|
  #      it "reports no smells in #{path}" do
  #        expect(path).not_to improve_your_code
  #      end
  #    end
  #  end
  #
  # And here's an even simpler way to do the same:
  #
  #  it 'has no code smells' do
  #    Pathname.glob('lib/**/*.rb').each do |path|
  #      expect(path).not_to improve_your_code
  #    end
  #  end
  #
  # Here's a simple check of a code fragment:
  #
  #  'def equals(other) other.thing == self.thing end'.should_not improve_your_code
  #
  # To check for specific smells, use something like this:
  #
  #   ruby = 'def double_thing() @other.thing.foo + @other.thing.foo end'
  #   ruby.should improve_your_code_of(:DuplicateMethodCall, name: '@other.thing')
  #   ruby.should improve_your_code_of(:DuplicateMethodCall, name: '@other.thing.foo', count: 2)
  #   ruby.should_not improve_your_code_of(:FeatureEnvy)
  #
  # @public
  module Spec
    #
    # Checks the target source code for instances of "smell type"
    # and returns true only if it can find one of them that matches.
    #
    # You can pass the smell type you want to check for as String or as Symbol:
    #
    #   - :UtilityFunction
    #   - "UtilityFunction"
    #
    # It is recommended to pass this as a symbol like :UtilityFunction. However we don't
    # enforce this.
    #
    # Additionally you can be more specific and pass in "smell_details" you
    # want to check for as well e.g. "name" or "count" (see the examples below).
    # The parameters you can check for are depending on the smell you are checking for.
    # For instance "count" doesn't make sense everywhere whereas "name" does in most cases.
    # If you pass in a parameter that doesn't exist (e.g. you make a typo like "namme") ImproveYourCode will
    # raise an ArgumentError to give you a hint that you passed something that doesn't make
    # much sense.
    #
    # @param smell_type [Symbol, String, Class] The "smell type" to check for.
    # @param smell_details [Hash] A hash containing "smell warning" parameters
    #
    # @example Without smell_details
    #
    #   improve_your_code_of(:FeatureEnvy)
    #   improve_your_code_of(:UtilityFunction)
    #
    # @example With smell_details
    #
    #   improve_your_code_of(:UncommunicativeParameterName, name: 'x2')
    #   improve_your_code_of(:DataClump, count: 3)
    #
    # @example From a real spec
    #
    #   expect(src).to improve_your_code_of(:DuplicateMethodCall, name: '@other.thing')
    #
    # @public
    #
    # :improve_your_code:UtilityFunction
    def improve_your_code_of(smell_type,
                smell_details = {},
                configuration = Configuration::AppConfiguration.default)
      ShouldImproveYourCodeOf.new(smell_type, smell_details, configuration)
    end

    #
    # See the documentaton for "improve_your_code_of".
    #
    # Notable differences to improve_your_code_of:
    #   1.) "improve_your_code_of" doesn't mind if there are other smells of a different type.
    #       "improve_your_code_only_of" will fail in that case.
    #   2.) "improve_your_code_only_of" doesn't support the additional smell_details hash.
    #
    # @param smell_type [Symbol, String, Class] The "smell type" to check for.
    #
    # @public
    #
    # :improve_your_code:UtilityFunction
    def improve_your_code_only_of(smell_type, configuration = Configuration::AppConfiguration.default)
      ShouldImproveYourCodeOnlyOf.new(smell_type, configuration)
    end

    #
    # Returns +true+ if and only if the target source code contains smells.
    #
    # @public
    #
    # :improve_your_code:UtilityFunction
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
