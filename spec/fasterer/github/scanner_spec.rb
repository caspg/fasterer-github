require 'spec_helper'
require 'fasterer/github/scanner'

describe Fasterer::Github::Scanner do
  subject { described_class.new('owner', 'repo', 'path') }

  let(:collected_data) { TraverserResults.test_data }

  before do
    traverser = double
    allow(Fasterer::Github::GhTraverser).to receive(:new)
      .with('owner', 'repo', 'path').and_return(traverser)
    allow(traverser).to receive(:traverse)
    allow(traverser).to receive(:api_errors).and_return([])
    allow(traverser).to receive(:collected_data).and_return(collected_data)
  end

  let(:detected_offences) do
    [:hash_merge_bang_vs_hash_brackets, :fetch_with_argument_vs_block]
  end

  it 'analyze files and returns correct result' do
    subject.run
    result = subject.results
    result_keys = [:repo_owner, :repo_name, :fasterer_offences, :errors, :api_errors]

    expect(result.class).to eq(Hash)
    expect(result.keys).to eq(result_keys)
    expect(result[:fasterer_offences].keys).to eq(detected_offences)
  end
end
