require 'spec_helper'
require 'fasterer/github/api_wrapper'

describe Fasterer::Github::ApiWrapper do
  describe '#contents' do
    subject { described_class.new(owner, repo).contents(path) }

    let(:owner) { 'caspg' }
    let(:repo) { 'fasterer-github' }

    before(stub_request: true) do
      allow(HTTParty).to receive(:get) { SuccessResponse.new }
    end

    context 'when client_secret and client_id are not specified' do
      context 'when path is nil' do
        let(:path) { nil }

        it 'makes request with correct url', stub_request: true do
          subject

          url = 'https://api.github.com/repos/caspg/fasterer-github/contents/'
          expect(HTTParty).to have_received(:get).with(url)
        end

        it 'returns an array with repo/folder data', vcr: { cassette_name: 'folder_data' } do
          expect(subject.parsed_response.class).to eq(Array)
        end
      end

      context 'when path is not nil' do
        let(:path) { 'lib/fasterer-github.rb' }

        it 'makes request with correct url', stub_request: true do
          subject

          url = 'https://api.github.com/repos/caspg/fasterer-github/contents/lib/fasterer-github.rb'
          expect(HTTParty).to have_received(:get).with(url)
        end

        it 'returns a hash with file data', vcr: { cassette_name: 'file_data' } do
          expect(subject.parsed_response.class).to eq(Hash)
        end
      end
    end

    context 'when client_secret and client_id are specified' do
      before do
        Fasterer::Github.configure do |config|
          config.client_id = 'client_id'
          config.client_secret = 'client_secret'
        end
      end

      after(:each) { Fasterer::Github.reset_configuration }

      let(:path) { nil }

      it 'makes request with correct url', stub_request: true do
        subject
        url = 'https://api.github.com/repos/caspg/fasterer-github/contents/'
        url += '?client_id=client_id&client_secret=client_secret'

        expect(HTTParty).to have_received(:get).with(url)
      end
    end
  end
end
