require 'httparty'

module GhFasterer
  class ApiWrapper
    BASE_URL = 'https://api.github.com'

    def initialize(owner, repo)
      @owner = owner
      @repo = repo
      @client_id = GhFasterer.configuration.client_id.to_s
      @client_secret = GhFasterer.configuration.client_secret.to_s
    end

    def contents(path)
      url = build_url(path)
      HTTParty.get(url)
    end

    private

    attr_reader :owner, :repo, :path, :client_id, :client_secret

    def build_url(path)
      url = BASE_URL + "/repos/#{owner}/#{repo}/contents/#{path}"
      return url if client_id == '' && client_secret == ''
      url + "?client_id=#{client_id}&client_secret=#{client_secret}"
    end
  end
end
