# frozen_string_literal: true

require 'rspec/core/rake_task'

begin
  require 'voxpupuli/rubocop/rake'
rescue LoadError
  # the voxpupuli-rubocop gem is optional
end

begin
  require 'rubygems'
  require 'github_changelog_generator/task'

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix skip-changelog modulesync github_actions]
    config.user = 'voxpupuli'
    config.project = 'beaker-hcloud'
    config.future_release = Gem::Specification.load("#{config.project}.gemspec").version
  end
rescue LoadError # rubocop:disable Lint/SuppressedException
end

RSpec::Core::RakeTask.new(:spec)
task default: %i[spec]
