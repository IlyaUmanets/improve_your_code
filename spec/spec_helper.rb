require 'pathname'
require 'timeout'
require 'active_support/core_ext/string/strip'
require_relative '../lib/improve_your_code'
require_relative '../lib/improve_your_code/spec'
require_relative '../lib/improve_your_code/ast/ast_node_class_map'
require_relative '../lib/improve_your_code/configuration/app_configuration'

require_relative '../samples/paths'

ImproveYourCode::CLI::Silencer.silently do
  begin
    require 'pry-byebug'
  rescue LoadError # rubocop:disable Lint/HandleExceptions
  end
end

require 'factory_bot'
FactoryBot.find_definitions

# Simple helpers for our specs.
module Helpers
  def test_configuration_for(config)
    case config
    when Pathname
      configuration = ImproveYourCode::Configuration::AppConfiguration.from_path(config)
    when Hash
      configuration = ImproveYourCode::Configuration::AppConfiguration.from_hash config
    else
      raise "Unknown config given in `test_configuration_for`: #{config.inspect}"
    end
    configuration
  end

  # @param code [String] The given code.
  #
  # @return syntax_tree [ImproveYourCode::AST::Node]
  def syntax_tree(code)
    ImproveYourCode::Source::SourceCode.from(code).syntax_tree
  end

  # @param code [String] The given code.
  #
  # @return syntax_tree [ImproveYourCode::Context::CodeContext]
  def code_context(code)
    ImproveYourCode::Context::CodeContext.new(nil, syntax_tree(code))
  end

  # @param code [String] The given code.
  #
  # @return syntax_tree [ImproveYourCode::Context::MethodContext]
  def method_context(code)
    ImproveYourCode::Context::MethodContext.new(nil, syntax_tree(code))
  end

  # Helper methods to generate a configuration for smell types that support
  # `accept` and `reject` settings.
  %w(accept reject).each do |switch|
    define_method("#{switch}_configuration_for") do |smell_type, pattern:|
      hash = {
        smell_type => {
          switch => pattern
        }
      }
      ImproveYourCode::Configuration::AppConfiguration.from_hash(hash)
    end
  end

  # :improve_your_code:UncommunicativeMethodName
  def sexp(type, *children)
    @klass_map ||= ImproveYourCode::AST::ASTNodeClassMap.new
    @klass_map.klass_for(type).new(type, children)
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.include FactoryBot::Syntax::Methods
  config.include Helpers

  config.disable_monkey_patching!

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.verify_doubled_constant_names = true
  end

  # Avoid infinitely running tests. This is mainly useful when running a
  # mutation tester. Set the DEBUG environment variable to something truthy
  # like '1' to disable this and allow using pry without specs failing.
  unless ENV['DEBUG']
    config.around do |example|
      Timeout.timeout(5, &example)
    end
  end
end

RSpec::Matchers.define_negated_matcher :not_improve_your_code_of, :improve_your_code_of

private

def require_lib(path)
  require_relative "../lib/#{path}"
end
