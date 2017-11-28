source 'https://rubygems.org'

gemspec

ruby RUBY_VERSION

group :development do
  gem 'activesupport', '>= 4.2'
  gem 'aruba',         '~> 0.14.0'
  gem 'cucumber',      '~> 3.0'
  gem 'factory_bot',   '~> 4.0'
  gem 'rake',          '~> 12.0'
  gem 'rspec',         '~> 3.0'

  if RUBY_VERSION >= '2.3'
    gem 'rubocop',       '~> 0.51.0'
    gem 'rubocop-rspec', '~> 1.20.0'
  end

  platforms :mri do
    gem 'redcarpet', '~> 3.4.0'
  end
end

group :debugging do
  # Fixing https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X#option-4-using-a-pure-ruby-readline-implementation
  gem 'pry'
  gem 'rb-readline', '~> 0.5.3'
  platforms :mri do
    gem 'pry-byebug'
    gem 'pry-stack_explorer'
  end
end