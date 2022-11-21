# frozen_string_literal: true

if ENV['COVERAGE'] == 'yes'
  require 'simplecov'
  require 'simplecov-console'
  require 'codecov'

  SimpleCov.start do
    track_files 'lib/**/*.rb'

    add_filter '/spec'

    enable_coverage :branch

    # do not track vendored files
    add_filter '/vendor'
    add_filter '/.vendor'
  end

  SimpleCov.formatters = [
    SimpleCov::Formatter::Console,
    SimpleCov::Formatter::Codecov,
  ]
end
$LOAD_PATH.unshift File.expand_path('lib', __dir__)

require 'beaker'
require 'beaker-hcloud/version'
require 'beaker/hypervisor/hcloud'
