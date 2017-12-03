# frozen_string_literal: true

require File.join(File.dirname(__FILE__), 'lib/improve_your_code/version')

Gem::Specification.new do |s|
  s.name = 'improve_your_code'
  s.version = ImproveYourCode::Version::STRING

  s.authors = ['Ilya Umanets']
  s.email = 'ilya.umanets.web@gmail.com'
  s.homepage = 'https://github.com/IlyaUmanets/improve_your_code'
  s.default_executable = 'improve_your_code'
  s.description =
    'ImproveYourCode is a tool that examines Ruby classes, modules and methods and reports ' \
    'any code smells it finds.'

  s.files = `git ls-files -z`.split("\0")
  s.executables = s.files.grep(%r{^bin/}).map { |path| File.basename(path) }
  s.required_ruby_version = '>= 2.1.0'
  s.summary = 'Code smell detector for Ruby'

  s.add_runtime_dependency 'parser', '< 2.5', '>= 2.4.0.0'
  s.add_runtime_dependency 'rainbow', '~> 2.0'
end
