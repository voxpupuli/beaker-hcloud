# frozen_string_literal: true

module Beaker
  # beaker extenstion to manage cloud instances from https://www.hetzner.com/cloud
  class Hcloud < Beaker::Hypervisor
    # @param [Host, Array<Host>, String, Symbol] hosts One or more hosts to act upon, or a role (String or Symbol) that identifies one or more hosts.
    # @param [Hash{Symbol=>String}] options Options to pass on to the hypervisor
    def initialize(hosts, options) # rubocop:disable Lint/MissingSuper
      require 'hcloud'
      @options = options
      @logger = options[:logger] || Beaker::Logger.new
      @hosts = hosts

      raise 'You need to pass a token as HCLOUD_TOKEN environment variable' unless ENV['HCLOUD_TOKEN']

      @client = Hcloud::Client.new(token: ENV.fetch('HCLOUD_TOKEN'))
    end

    def provision
      @logger.notify 'Provisioning docker'
      @hosts.each do |host|
        @logger.notify "provisioning #{host.name}"
      end
    end

    def cleanup
      @logger.notify 'Cleaning up docker'
      @hosts.each do |host|
        # @logger.debug("stop VM #{container.id}")
      end
    end
  end
end
