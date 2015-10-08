require 'spec_helper'
require 'gh_fasterer/output_composer'

describe GhFasterer::OutputComposer do
  subject { described_class.new(repo_owner, repo_name) }

  let(:repo_owner) { 'repo_owner' }
  let(:repo_name) { 'repo_name' }
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
        repo_owner: repo_owner,
        repo_name: repo_name,
        fasterer_offences: {
          hash_merge_bang_vs_hash_brackets: [
            { file_name: 'file name', url: 'some_url', lines: [10, 19] }
          ],
          fetch_with_argument_vs_block: [
            { file_name: 'file name', url: 'some_url', lines: [26] },
            { file_name: 'another file name', url: 'another_url', lines: [13] }
          ]
        },
        errors: [],
        api_errors: []
      }
    end

    it 'returns correct result' do
      subject.add_offences(offences, url, file_name)
      subject.add_offences(another_offences, another_url, another_file_name)
      expect(subject.result).to eq(expected_result)
    end
  end

  describe '#add_errors' do
    let(:expected_result) do
      {
        repo_owner: repo_owner,
        repo_name: repo_name,
        fasterer_offences: {},
        errors: [
          { url: url, file_name: file_name },
          { url: another_url, file_name: another_file_name }
        ],
        api_errors: []
      }
    end

    it 'returns correct result' do
      subject.add_errors(url, file_name)
      subject.add_errors(another_url, another_file_name)
      expect(subject.result).to eq(expected_result)
    end
  end

  describe '#add_api_errors' do
    let(:api_errors) { [{ code: 404, body: 'some 404 msg' }] }
    let(:expected_result) do
      {
        repo_owner: repo_owner,
        repo_name: repo_name,
        fasterer_offences: {},
        errors: [],
        api_errors: [
          { code: 404, body: 'some 404 msg' }
        ]
      }
    end

    it 'returns correct result' do
      subject.add_api_errors(api_errors)
      expect(subject.result).to eq(expected_result)
    end
  end
end
