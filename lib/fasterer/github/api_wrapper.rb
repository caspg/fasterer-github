require 'httparty'

module Fasterer
  module Github
    class ApiWrapper
      BASE_URL = 'https://api.github.com'

      def initialize(owner, repo)
        @owner = owner
        @repo = repo
        @access_token = Fasterer::Github.configuration.access_token.to_s
        @client_id = Fasterer::Github.configuration.client_id.to_s
        @client_secret = Fasterer::Github.configuration.client_secret.to_s
      end

      def contents(path)
        url = build_url(path)
        HTTParty.get(url)
      end

      private

      attr_reader :owner, :repo, :path, :client_id, :client_secret, :access_token

      def build_url(path)
        url = BASE_URL + "/repos/#{owner}/#{repo}/contents/#{path}"
        return add_access_token(url) if access_token != ''
        return add_client_id_and_secret(url) if client_id != '' && client_secret != ''
        url
      end

      def add_access_token(url)
        url + "?access_token=#{access_token}"
      end

      def add_client_id_and_secret(url)
        url + "?client_id=#{client_id}&client_secret=#{client_secret}"
      end
    end
  end
end
