require 'spec_helper'

describe Fasterer::Github do
  it 'has a version number' do
    expect(Fasterer::Github::VERSION).not_to be nil
  end

  describe '.scan' do
    let(:owner) { 'owner' }
    let(:repo) { 'repo' }

    it 'calls correct methods' do
      scanner = double
      expect(Fasterer::Github::Scanner).to receive(:new).with(owner, repo, nil) { scanner }
      expect(scanner).to receive(:run)
      expect(scanner).to receive(:results)

      subject.scan(owner, repo)
    end
  end
end
