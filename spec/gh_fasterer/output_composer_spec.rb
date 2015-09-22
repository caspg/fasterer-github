require 'spec_helper'
require 'gh_fasterer/output_composer'

describe GhFasterer::OutputComposer do
  subject { described_class.new }

  let(:offences) do
    {
      hash_merge_bang_vs_hash_brackets: [10, 19],
      fetch_with_argument_vs_block: [26]
    }
  end
  let(:another_offences) { { fetch_with_argument_vs_block: [13] } }
  let(:url) { 'some_url' }
  let(:another_url) { 'another_url' }
  let(:file_name) { 'file name' }
  let(:another_file_name) { 'another file name' }

  describe '#add_offences' do
    let(:expected_result) do
      {
        fasterer_offences: {
          hash_merge_bang_vs_hash_brackets: [
            { file_name: 'file name', url: 'some_url', lines: [10, 19] }
          ],
          fetch_with_argument_vs_block: [
            { file_name: 'file name', url: 'some_url', lines: [26] },
            { file_name: 'another file name', url: 'another_url', lines: [13] }
          ]
        }
      }
    end

    it 'returns correct result' do
      subject.add_offences(offences, url, file_name)
      subject.add_offences(another_offences, another_url, another_file_name)
      expect(subject.result).to eq(expected_result)
    end
  end
end
