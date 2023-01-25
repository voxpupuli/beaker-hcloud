# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers, RSpec/VerifiedDoubles, RSpec/FilePath
describe Beaker::Hcloud do
  let(:logger_double) do
    double(:logger).as_null_object
  end
  let(:options) do
    opts = Beaker::Options::Presets.new
    opts.presets
        .merge(opts.env_vars)
        .merge({
                 logger: logger_double,
                 timestamp: Time.now
               })
  end
  let(:host1_hash) do
    {
      hypervisor: 'hcloud',
      image: 'ubuntu-20.04'
    }
  end
  let(:host2_hash) do
    {
      hypervisor: 'hcloud',
      image: 'custom image',
      location: 'custom location',
      server_type: 'custom type'
    }
  end
  let(:hosts) do
    [[1, host1_hash], [2, host2_hash]].map do |number, host_hash|
      host_hash = Beaker::Options::OptionsHash.new.merge(host_hash)
      Beaker::Host.create("Server #{number}", host_hash, options)
    end
  end
  let(:server1) do
    double(:server1,
           id: 1,
           public_net: {
             'ipv4' => {
               'ip' => '192.168.0.1',
               'dns_ptr' => 'server1.example.com'
             }
           },
           destroy: true)
  end
  let(:server2) do
    double(:server2,
           id: 2,
           public_net: {
             'ipv4' => {
               'ip' => '192.168.0.2',
               'dns_ptr' => 'server2.example.com'
             }
           },
           destroy: true)
  end
  let(:action_double) do
    double(:action, status: 'success')
  end
  let(:actions_double) do
    double(:actions, find: action_double)
  end
  let(:servers_double) do
    servers_double = double(:servers)
    allow(servers_double).to receive(:create)
      .and_return([action_double, server1], [action_double, server2])
    allow(servers_double).to receive(:find)
      .and_return(server1, server2)
    servers_double
  end
  let(:key_double) do
    double(:key, id: 23, destroy: true)
  end
  let(:ssh_keys_double) do
    double(:ssh_keys, create: key_double, find: key_double)
  end
  let(:hcloud_client) do
    double(:hcloud_client,
           actions: actions_double,
           servers: servers_double,
           ssh_keys: ssh_keys_double)
  end
  let(:hcloud) do
    described_class.new(hosts, options)
  end

  before do
    ENV['BEAKER_HCLOUD_TOKEN'] = 'abc'
    allow(Hcloud::Client).to receive(:new).and_return(hcloud_client)
  end

  describe '#provision', :aggregate_failures do
    subject(:provision) { hcloud.provision }

    before { provision }
    after { hcloud.cleanup }

    it 'uploads an ssh key using the hcloud client' do
      expect(ssh_keys_double).to have_received(:create)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'creates one server for each host via the hcloud client' do
      expect(servers_double).to have_received(:create)
        .with(hash_including({
                               name: 'Server 1',
                               location: 'nbg1',
                               server_type: 'cx11',
                               image: 'ubuntu-20.04'
                             }))
      expect(servers_double).to have_received(:create)
        .with(hash_including({
                               name: 'Server 2',
                               location: 'custom location',
                               server_type: 'custom type',
                               image: 'custom image'
                             }))
    end
    # rubocop:enable RSpec/ExampleLength

    it "saves ip and dns name to the host's settings" do
      host1, host2 = hosts
      expect(host1[:ip]).to eq '192.168.0.1'
      expect(host1[:vmhostname]).to eq 'server1.example.com'
      expect(host2[:ip]).to eq '192.168.0.2'
      expect(host2[:vmhostname]).to eq 'server2.example.com'
    end

    it "saves hcloud's server id with the host's settings" do
      host1, host2 = hosts
      expect(host1[:hcloud_id]).to eq 1
      expect(host2[:hcloud_id]).to eq 2
    end

    it "saves the path to the temporary ssh key with the host's options" do
      host1, host2 = hosts
      expect(host1[:ssh][:keys].size).to eq 1
      expect(host2[:ssh][:keys].size).to eq 1
    end
  end

  describe '#cleanup' do
    subject(:cleanup) { hcloud.cleanup }

    before do
      hcloud.provision
      cleanup
    end

    it 'destroys first server' do
      expect(server1).to have_received(:destroy)
    end

    it 'destroys last server' do
      expect(server2).to have_received(:destroy)
    end

    it 'destroys the temporary ssh key' do
      expect(key_double).to have_received(:destroy)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers, RSpec/VerifiedDoubles, RSpec/FilePath
