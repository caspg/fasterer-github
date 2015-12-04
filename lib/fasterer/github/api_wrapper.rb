require 'httparty'

module Fasterer
  module Github
    class ApiWrapper
      BASE_URI = 'https://api.github.com'

      def initialize(owner, repo)
        @owner = owner
        @repo = repo
        @access_token = Fasterer::Github.configuration.access_token.to_s
        @client_id = Fasterer::Github.configuration.client_id.to_s
        @client_secret = Fasterer::Github.configuration.client_secret.to_s
      end

      def contents(path)
        HTTParty.get(build_uri(path), query: authorization_params)
      end

      private

      attr_reader :owner, :repo, :path, :client_id, :client_secret, :access_token

      def build_uri(path)
        URI.escape(BASE_URI + "/repos/#{owner}/#{repo}/contents/#{path}")
      end

      def authorization_params
        return access_token_hash unless access_token.empty?
        return client_id_secret_hash unless client_id.empty? && client_secret.empty?
      end

      def access_token_hash
        { 'access_token' => access_token }
      end

      def client_id_secret_hash
        { 'client_id' => client_id, 'client_secret' => client_secret }
      end
    end
  end
end
