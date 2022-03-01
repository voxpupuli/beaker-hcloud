Gem::Specification.new do |s|
  s.name        = 'beaker-hetzner'
  s.version     = '1.0.0'
  s.summary     = "Hetzner Library for beaker acceptance testing framework"
  s.description = s.summary
  s.authors     = ['Tim Meusel', 'Vox Pupuli']
  s.email       = 'voxpupuli@groups.io'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/voxpupuli/beaker-hetzner'
  s.license     = 'AGPL-3'

  s.add_runtime_dependency 'hcloud', '>= 1.0.3'
end
