require 'spec_helper'
require 'gh_fasterer/api_wrapper'

describe GhFasterer::ApiWrapper do
  describe '#contents' do
    subject { described_class.new(owner, repo).contents(path) }

    let(:owner) { 'owner' }
    let(:repo) { 'repo' }

    before do
      allow(HTTParty).to receive(:get) { StubbedResponse.new }
    end

    context 'when path is nil' do
      let(:path) { nil }

      it 'makes request with correct url' do
        subject

        url = 'https://api.github.com/repos/owner/repo/contents/'
        expect(HTTParty).to have_received(:get).with(url)
      end
    end

    context 'when path is not nil' do
      let(:path) { 'path/to/file.rb' }

      it 'makes request with correct url' do
        subject

        url = 'https://api.github.com/repos/owner/repo/contents/path/to/file.rb'
        expect(HTTParty).to have_received(:get).with(url)
      end
    end
  end
end
