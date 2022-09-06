# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'beaker-hcloud/version'

Gem::Specification.new do |s|
  s.name        = 'beaker-hcloud'
  s.version     = BeakerHcloud::VERSION
  s.summary     = 'Hetzner Library for beaker acceptance testing framework'
  s.description = 'Another gem that extends beaker'
  s.authors     = ['Tim Meusel', 'Vox Pupuli']
  s.email       = 'voxpupuli@groups.io'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/voxpupuli/beaker-hcloud'
  s.license     = 'AGPL-3.0'

  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '~> 1.25'
  s.add_development_dependency 'rubocop-rake', '~> 0.6'
  s.add_development_dependency 'rubocop-rspec', '~> 2.9'
  s.add_runtime_dependency 'beaker', '~> 4.34'
  s.add_runtime_dependency 'hcloud', '>= 1.0.3', '< 2.0.0'
end
