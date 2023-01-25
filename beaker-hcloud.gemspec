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

  s.add_runtime_dependency 'bcrypt_pbkdf', '~> 1.0'
  s.add_runtime_dependency 'beaker', '~> 4.38'
  s.add_runtime_dependency 'ed25519', '~> 1.2'
  s.add_runtime_dependency 'hcloud', '>= 1.0.3', '< 2.0.0'
  s.add_runtime_dependency 'ssh_data', '~> 1.3'
end
