require 'spec_helper'
require 'gh_fasterer/gh_traverser'

describe GhFasterer::GhTraverser do
  let(:attributes) { %i(url content64 name) }

  context 'when traversing repo', vcr: { cassette_name: 'traversed_repo' } do
    let!(:traverser) { described_class.new('caspg', 'gh_fasterer', '') }
    let!(:traverser_content) do
      traverser.traverse
      traverser.urls_with_content
    end

    it 'returns an array with hashes containing correct attributes' do
      expect(traverser_content.class).to eq(Array)

      traverser_content.each do |item|
        expect(item.class).to eq(Hash)
        expect(item.keys).to eq(attributes)

        attributes.each do |attribute|
          expect(item[attribute.to_sym]).not_to eq(nil)
        end
      end
    end

    it 'contains only ruby files' do
      files_names = traverser_content.map { |i| i[:name] }
      files_names.each do |name|
        expect(name =~ /.rb$/).not_to eq(nil)
      end
    end
  end
end
