require 'fasterer/github/version'
require 'fasterer/github/scanner'
require 'fasterer/github/configuration'

module Fasterer
  module Github
    def self.scan(owner, repo, path = nil)
      scanner = Fasterer::Github::Scanner.new(owner, repo, path)
      scanner.run
      scanner.results
    end
  end
end
