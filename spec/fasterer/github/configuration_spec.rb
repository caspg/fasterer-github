require 'spec_helper'
require 'fasterer/github/configuration'

describe Fasterer::Github::Configuration do
  subject { Fasterer::Github }

  after { Fasterer::Github.reset_configuration }

  context 'when client_id is not specified' do
    before do
      subject.configure do |configure|
      end
    end

    it 'uses defaults value' do
      expect(subject.configuration.client_id).to eq(nil)
    end
  end

  context 'when client_id is specified' do
    before do
      subject.configure do |config|
        config.client_id = 'client_id'
      end
    end

    it 'is used instead of default' do
      expect(subject.configuration.client_id).to eq('client_id')
    end
  end

  context 'when client_secret is not specified' do
    before do
      subject.configure do |configure|
      end
    end

    it 'uses defaults value' do
      expect(subject.configuration.client_secret).to eq(nil)
    end
  end

  context 'when client_secret is specified' do
    before do
      subject.configure do |config|
        config.client_secret = 'client_secret'
      end
    end

    it 'is used instead of default' do
      expect(subject.configuration.client_secret).to eq('client_secret')
    end
  end
end
