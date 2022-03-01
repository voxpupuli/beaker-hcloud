source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

group :coverage, optional: ENV['COVERAGE']!='yes' do
  gem 'simplecov-console', :require => false
  gem 'codecov', :require => false
end
