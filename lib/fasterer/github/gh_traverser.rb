require_relative 'api_wrapper'

module Fasterer
  module Github
    class GhTraverser
      def initialize(owner, repo, path)
        @owner = owner
        @repo = repo
        @path = path.to_s
      end

      def traverse
        catch(:rate_limit) { collect_data(path) }
      end

      def collected_data
        @collected_data ||= []
      end

      def api_errors
        @api_errors ||= []
      end

      private

      attr_reader :owner, :repo, :path

      def wrapper
        @wrapper ||= Fasterer::Github::ApiWrapper.new(owner, repo)
      end

      def collect_data(path)
        response = wrapper.contents(path)
        return store_api_error(response, path) unless response.code < 400
        parsed_response = response.parsed_response

        if parsed_response.is_a?(Hash)
          return unless match_regex?(parsed_response['path'])
          store_data(parsed_response)
        else
          parsed_response.each { |item| collect_data(item['path']) }
        end
      end

      def store_api_error(response, path)
        response_code = response.code
        api_errors << { code: response_code, msg_body: response.body, path: path }
        throw(:rate_limit) if rate_limit_error?(response)
      end

      def rate_limit_error?(response)
        response.code == 403 && response.body =~ /rate limit exceeded/i
      end

      def store_data(response)
        file_data = { path: response['path'], content64: response['content'] }
        collected_data << file_data
      end

      def match_regex?(file_name)
        file_name =~ /\.rb$/
      end
    end
  end
end