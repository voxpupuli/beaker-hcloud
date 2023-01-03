# frozen_string_literal: true

require 'hcloud'
require 'ed25519'
require 'bcrypt_pbkdf'

require_relative '../../beaker-hcloud/ssh_data_patches'

module Beaker
  # beaker extension to manage cloud instances from https://www.hetzner.com/cloud
  class Hcloud < Beaker::Hypervisor
    # @param [Host, Array<Host>, String, Symbol] hosts One or more hosts to act upon, or a role (String or Symbol) that identifies one or more hosts.
    # @param [Hash{Symbol=>String}] options Options to pass on to the hypervisor
    def initialize(hosts, options) # rubocop:disable Lint/MissingSuper
      @options = options
      @logger = options[:logger] || Beaker::Logger.new
      @hosts = hosts

      raise 'You need to pass a token as BEAKER_HCLOUD_TOKEN environment variable' unless ENV['BEAKER_HCLOUD_TOKEN']

      @client = ::Hcloud::Client.new(token: ENV.fetch('BEAKER_HCLOUD_TOKEN'))
    end

    def provision
      @logger.notify 'Provisioning hcloud'
      create_ssh_key
      @hosts.each do |host|
        create_server(host)
      end
      @logger.notify 'Done provisioning hcloud'
    end

    def cleanup
      @logger.notify 'Cleaning up hcloud'
      @hosts.each do |host|
        @logger.debug("Deleting hcloud server #{host.name}")
        @client.servers.find(host[:hcloud_id]).destroy
      end
      @logger.notify 'Deleting hcloud SSH key'
      @client.ssh_keys.find(@options[:ssh][:hcloud_id]).destroy
      File.unlink(@key_file.path)
      @logger.notify 'Done cleaning up hcloud'
    end

    private

    def ssh_key_name
      safe_hostname = Socket.gethostname.gsub('.', '-')
      [
        'Beaker',
        ENV.fetch('USER', nil),
        safe_hostname,
        @options[:aws_keyname_modifier],
        @options[:timestamp].strftime('%F_%H_%M_%S_%N'),
      ].join('-')
    end

    def create_ssh_key
      @logger.notify 'Generating SSH keypair'
      ssh_key = SSHData::PrivateKey::ED25519.generate
      @key_file = Tempfile.create(ssh_key_name)
      File.write(@key_file.path, ssh_key.openssh(comment: ssh_key_name))
      @logger.notify 'Creating hcloud SSH key'
      hcloud_ssh_key = @client.ssh_keys.create(
        name: ssh_key_name,
        public_key: ssh_key.public_key.openssh(comment: ssh_key_name)
      )
      @options[:ssh][:hcloud_id] = hcloud_ssh_key.id
      hcloud_ssh_key
    end

    def create_server(host)
      @logger.notify "provisioning #{host.name}"
      location = host[:location] || 'nbg1'
      server_type = host[:server_type] || 'cx11'
      action, server = @client.servers.create(
        name: host.name,
        location: location,
        server_type: server_type,
        image: host[:image],
        ssh_keys: [ssh_key_name]
      )
      while action.status == 'running'
        sleep 5
        action = @client.actions.find(action.id)
        server = @client.servers.find(server.id)
      end
      host[:ip] = server.public_net['ipv4']['ip']
      host[:vmhostname] = server.public_net['ipv4']['dns_ptr']
      host[:hcloud_id] = server.id
      host.options[:ssh][:keys] = [@key_file.path]
      server
    end
  end
end
