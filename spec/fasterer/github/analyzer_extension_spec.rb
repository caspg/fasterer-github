require 'spec_helper'
require 'fasterer/github/analyzer_extension'
require 'base64'

describe Fasterer::Github::AnalyzerExtension do
  subject { described_class.new(encoded_content) }

  it 'inherits class from fasterer gem' do
    expect(described_class.superclass).to eq(Fasterer::Analyzer)
  end

  context 'when initializing' do
    let(:encoded_content) { Base64.encode64('some content') }
    let(:decoded_content) { Base64.decode64(encoded_content) }

    it 'decodes file content' do
      expect(subject.instance_variable_get(:@file_content)).to eq(decoded_content)
    end
  end

  describe 'offences' do
    let(:encoded_content) { Fasterer::Github::TestData.content64_with_offences }
    let(:expected_result) do
      {
        hash_merge_bang_vs_hash_brackets: [10, 17, 19],
        fetch_with_argument_vs_block: [26]
      }
    end
    let(:analyzer_offences) do
      analyzer = subject
      analyzer.scan
      analyzer.offences
    end

    it 'returns offences names with lines of its occurrence' do
      expect(analyzer_offences).to eq(expected_result)
    end
  end
end
