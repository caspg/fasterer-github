require 'httparty'

module GhFasterer
  class ApiWrapper
    BASE_URL = 'https://api.github.com'

    def initialize(owner, repo)
      @owner = owner
      @repo = repo
    end

    def contents(path)
      url = BASE_URL + "/repos/#{owner}/#{repo}/contents/#{path}"
      HTTParty.get(url)
    end

    private

    attr_reader :owner, :repo, :path
  end
end
