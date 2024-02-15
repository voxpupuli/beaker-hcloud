# frozen_string_literal: true

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'hcloud', git: 'https://github.com/bastelfreak/hcloud-ruby', branch: 'dep'

gemspec

group :coverage, optional: ENV['COVERAGE'] != 'yes' do
  gem 'codecov', require: false
  gem 'simplecov-console', require: false
end

group :release, optional: true do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.16.4', require: false
end
