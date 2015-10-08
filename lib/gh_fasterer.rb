require 'gh_fasterer/version'
require 'gh_fasterer/scanner'
require 'gh_fasterer/configuration'

module GhFasterer
  class << self
    def scan(owner:, repo:, path: nil)
      scanner = GhFasterer::Scanner.new(owner, repo, path)
      scanner.run
      scanner.results
    end
  end
end
