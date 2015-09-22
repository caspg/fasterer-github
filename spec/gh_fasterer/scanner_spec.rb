require 'spec_helper'
require 'gh_fasterer/scanner'

describe GhFasterer::Scanner do
  subject { described_class.new('owner', 'repo', 'path') }

  let(:collected_data) { TraverserResults.test_data }

  before do
    traverser = double
    allow(GhFasterer::GhTraverser).to receive(:new)
      .with('owner', 'repo', 'path').and_return(traverser)
    allow(traverser).to receive(:traverse)
    allow(traverser).to receive(:collected_data).and_return(collected_data)
  end

  let(:detected_offences) do
    [:hash_merge_bang_vs_hash_brackets, :fetch_with_argument_vs_block]
  end

  it 'analyze files and returns correct result' do
    subject.run
    result = subject.result

    expect(result.class).to eq(Hash)
    expect(result.keys).to eq([:fasterer_offences, :errors])
    expect(result[:fasterer_offences].keys).to eq(detected_offences)
  end
end