require_relative 'api_wrapper'

module GhFasterer
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
      @wrapper ||= GhFasterer::ApiWrapper.new(owner, repo)
    end

    def collect_data(path)
      response = wrapper.contents(path)
      return store_api_error(response) unless response.code < 400
      parsed_response = response.parsed_response

      if parsed_response.is_a?(Hash)
        return unless match_regex?(parsed_response['path'])
        store_data(parsed_response)
      else
        parsed_response.each { |item| collect_data(item['path']) }
      end
    end

    def store_api_error(response)
      response_code = response.code
      api_errors['errors'] << { code: response_code, msg_body: response.body }
      throw(:rate_limit) if rate_limit_error?(response)
    end

    def rate_limit_error?(response)
      response.code == 403 && response.body =~ /rate limit exceeded/i
    end

    def store_data(response)
      file_data = { url: response['url'], content64: response['content'], name: response['name'] }
      collected_data << file_data
    end

    def match_regex?(file_name)
      file_name =~ /(.rb)$/
    end
  end
end
