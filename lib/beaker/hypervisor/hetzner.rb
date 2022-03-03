# frozen_string_literal: true

module Beaker
  # beaker extenstion to manage cloud instances from https://www.hetzner.com/cloud
  class Hetzner < Beaker::Hypervisor
    # @param [Host, Array<Host>, String, Symbol] hosts One or more hosts to act upon, or a role (String or Symbol) that identifies one or more hosts.
    # @param [Hash{Symbol=>String}] options Options to pass on to the hypervisor
    def initialize(hosts, options) # rubocop:disable Lint/MissingSuper
      require 'hcloud'
      @options = options
      @logger = options[:logger] || Beaker::Logger.new
      @hosts = hosts

      raise 'You need to pass a token as HCLOUD_TOKEN environment variable' unless ENV['HCLOUD_TOKEN']

      @client = Hcloud::Client.new(token: ENV['HCLOUD_TOKEN'])
      @images = images
    end

    def provision
      @logger.notify "Provisioning #{@hosts.count} hcloud instance(s)"
      @hosts.each do |host|
        os, rel, _arch = host.platform.split('-')
        image = "#{os}-#{rel}"
        @logger.notify "provisioning #{host.name}"
        puts '=============='
        puts "Image is #{host.platform}"
        puts '=============='
        raise "image #{image} is not supported at hcloud. supported are: #{images}" unless image_supported(image)

        # TODO: figure the domain out. does that come from beaker-hostgenerator
        # TODO use ssh keys?
        _action, server, pw = @client.servers.create(name: 'moo5', server_type: 'cx11', image: image)

        binding.pry
      end
    end

    def cleanup
      @logger.notify "Cleaning up #{@hosts.count} hcloud instance(s)"
      @hosts.each do |host|
        # @logger.debug("stop VM #{container.id}")
      end
      # instead of drestroying all, we should save the ids somewhere and only destroy those
      @client.servers.all.each(&:destroy)
    end

    private

    # array of images that hetzner has
    # ["centos-7", "ubuntu-18.04", "debian-10", "ubuntu-20.04", "debian-11", "centos-stream-8", "rocky-8", "fedora-35", "centos-stream-9"]
    def images
      # TODO: migrate to os_favor/os_version
      # https://docs.hetzner.cloud/#images-get-all-images
      @client.images.select { |image| image.type == 'system' && image.status == 'available' }.map(&:name)
    end

    # takes the string from beaker and returns true if hetzner supports it
    def image_supported(image)
      @images.include?(image)
    end
  end
end
