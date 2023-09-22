# frozen_string_literal: true

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

gem 'rake'
gem 'rspec'
gem 'rubocop', '~> 1.56.3'
gem 'rubocop-rake', '~> 0.6'
gem 'rubocop-rspec', '~> 2.9'

group :coverage, optional: ENV['COVERAGE'] != 'yes' do
  gem 'codecov', require: false
  gem 'simplecov-console', require: false
end
