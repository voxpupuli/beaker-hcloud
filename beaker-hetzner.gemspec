Gem::Specification.new do |s|
  s.name        = 'beaker-hetzner'
  s.version     = '1.0.0'
  s.summary     = 'Hetzner Library for beaker acceptance testing framework'
  s.description = 'Another gem that extends beaker'
  s.authors     = ['Tim Meusel', 'Vox Pupuli']
  s.email       = 'voxpupuli@groups.io'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/voxpupuli/beaker-hetzner'
  s.license     = 'AGPL-3.0'

  s.add_development_dependency 'rubocop', '~> 1.25'
  s.add_development_dependency 'rake'
  s.add_runtime_dependency 'hcloud', '>= 1.0.3', '< 2.0.0'
  s.add_runtime_dependency 'beaker', '~> 4.34'
end
