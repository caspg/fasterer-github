require 'spec_helper'
require 'gh_fasterer/gh_traverser'

describe GhFasterer::GhTraverser do
  let(:attributes) { %i(url content64 name) }

  context 'when traversing repo', vcr: { cassette_name: 'traversed_repo' } do
    let!(:traverser) { described_class.new('caspg', 'gh_fasterer', '') }
    let!(:traverser_results) do
      traverser.traverse
      traverser.collected_data
    end

    it 'returns an array with hashes containing correct attributes' do
      expect(traverser_results.class).to eq(Array)

      traverser_results.each do |item|
        expect(item.class).to eq(Hash)
        expect(item.keys).to eq(attributes)

        attributes.each do |attribute|
          expect(item[attribute.to_sym]).not_to eq(nil)
        end
      end
    end

    it 'contains only ruby files' do
      files_names = traverser_results.map { |i| i[:name] }
      files_names.each do |name|
        expect(name =~ /.rb$/).not_to eq(nil)
      end
    end
  end

  context 'when rate limit api error is encountered' do
    before do
      wrapper = double
      allow(GhFasterer::ApiWrapper).to receive(:new) { wrapper }
      allow(wrapper).to receive(:contents) { RateLimitResponse.new }
    end

    let!(:traverser) { described_class.new('caspg', 'gh_fasterer', 'test/path.rb') }
    let!(:traverser_api_errors) do
      traverser.traverse
      traverser.api_errors
    end

    it 'returns an array containing errors' do
      expect(traverser_api_errors.class).to eq(Array)
      expect(traverser_api_errors[0].keys).to eq([:code, :msg_body])
      expect(traverser_api_errors[0][:code]).to eq(403)
    end
  end
end
