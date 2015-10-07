require 'spec_helper'

describe GhFasterer do
  it 'has a version number' do
    expect(GhFasterer::VERSION).not_to be nil
  end

  describe '.scan' do
    let(:owner) { 'owner' }
    let(:repo) { 'repo' }

    it 'calls correct methods' do
      scanner = double
      expect(GhFasterer::Scanner).to receive(:new).with(owner, repo, nil) { scanner }
      expect(scanner).to receive(:run)
      expect(scanner).to receive(:results)

      subject.scan(owner: owner, repo: repo)
    end
  end
end
