require 'spec_helper'
require 'fasterer/github/gh_traverser'

describe Fasterer::Github::GhTraverser do
  let(:traverser) { described_class.new('caspg', 'fasterer-github', '', ignored_paths) }
  let(:attributes) { %i(path content64) }
  let(:ignored_paths) { [] }

  context 'when traversing repo', vcr: { cassette_name: 'traversed_repo' } do
    let(:traverser_results) do
      traverser.traverse
      traverser.collected_data
    end
    let(:files_paths) { traverser_results.map { |i| i[:path] } }

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
      files_paths.each do |name|
        expect(name =~ /.rb$/).not_to eq(nil)
      end
    end

    context 'when ignored_paths are empty' do
      let(:all_paths) do
        [
          "lib/fasterer-github.rb",
          "lib/fasterer-github/api_wrapper.rb",
          "lib/fasterer-github/version.rb",
          "spec/fasterer-github/api_wrapper_spec.rb",
          "spec/fasterer-github_spec.rb",
          "spec/spec_helper.rb"
        ]
      end

      it 'returns all files' do
        expect(files_paths).to eq(all_paths)
      end
    end

    context 'when ignored_paths are specified' do
      let(:ignored_paths) { ['lib/'] }
      let(:filtered_paths) do
        [
          "spec/fasterer-github/api_wrapper_spec.rb",
          "spec/fasterer-github_spec.rb",
          "spec/spec_helper.rb"
        ]
      end

      it 'returns filtered files' do
        expect(files_paths).to eq(filtered_paths)
      end
    end
  end

  context 'when rate limit api error is encountered' do
    before do
      wrapper = double
      allow(Fasterer::Github::ApiWrapper).to receive(:new) { wrapper }
      allow(wrapper).to receive(:contents) { RateLimitResponse.new }
    end

    let(:traverser_api_errors) do
      traverser.traverse
      traverser.api_errors
    end

    it 'returns an array containing errors' do
      expect(traverser_api_errors.class).to eq(Array)
      expect(traverser_api_errors[0].keys).to eq([:code, :msg_body, :path])
      expect(traverser_api_errors[0][:code]).to eq(403)
    end
  end
end
