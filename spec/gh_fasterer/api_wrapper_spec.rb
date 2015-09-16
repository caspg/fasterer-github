require 'spec_helper'
require 'gh_fasterer/api_wrapper'

describe GhFasterer::ApiWrapper do
  describe '#contents' do
    subject { described_class.new(owner, repo).contents(path) }

    let(:owner) { 'caspg' }
    let(:repo) { 'gh_fasterer' }

    before(stub_request: true) do
      allow(HTTParty).to receive(:get) { StubbedResponse.new }
    end

    context 'when path is nil' do
      let(:path) { nil }

      it 'makes request with correct url', stub_request: true do
        subject

        url = 'https://api.github.com/repos/caspg/gh_fasterer/contents/'
        expect(HTTParty).to have_received(:get).with(url)
      end

      it 'returns an array with repo/folder data', vcr: { cassette_name: 'folder_data' } do
        expect(subject.parsed_response.class).to eq(Array)
      end
    end

    context 'when path is not nil' do
      let(:path) { 'lib/gh_fasterer.rb' }

      it 'makes request with correct url', stub_request: true do
        subject

        url = 'https://api.github.com/repos/caspg/gh_fasterer/contents/lib/gh_fasterer.rb'
        expect(HTTParty).to have_received(:get).with(url)
      end

      it 'returns a hash with file data', vcr: { cassette_name: 'file_data' } do
        expect(subject.parsed_response.class).to eq(Hash)
      end
    end
  end
end
