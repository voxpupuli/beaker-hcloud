# frozen_string_literal: true

require 'spec_helper'

describe 'Beaker Hetzner integration' do
  context 'basic check' do
    it 'has a version number' do
      version = BeakerHetzner::VERSION
      expect(version).to eq '1.0.0'
    end
  end
end
