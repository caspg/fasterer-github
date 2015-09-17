require 'spec_helper'
require 'gh_fasterer/analyzer_extension'
require 'base64'

describe GhFasterer::AnalyzerExtension do
  it 'inherits class from fasterer gem' do
    expect(described_class.superclass).to eq(Fasterer::Analyzer)
  end

  context 'when initializing' do
    let(:encoded_content) { Base64.encode64('some content') }
    let(:decoded_content) { Base64.decode64(encoded_content) }

    subject { described_class.new(encoded_content) }

    it 'decodes file content' do
      expect(subject.instance_variable_get(:@file_content)).to eq(decoded_content)
    end
  end
end
