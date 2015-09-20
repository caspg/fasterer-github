require_relative 'api_wrapper'

module GhFasterer
  class GhTraverser
    attr_reader :collected_data

    def initialize(owner, repo, path)
      @owner = owner
      @repo = repo
      @path = path.to_s
      @collected_data = []
    end

    def traverse
      collect_data(path)
    end

    private

    attr_reader :owner, :repo, :path

    def collect_data(path)
      response = wrapper.contents(path).parsed_response
      if response.is_a?(Hash)
        return unless match_regex?(response['path'])
        store_data(response)
      else
        response.each { |item| collect_data(item['path']) }
      end
    end

    def wrapper
      @wrapper ||= GhFasterer::ApiWrapper.new(owner, repo)
    end

    def store_data(response)
      file_data = { url: response['url'], content64: response['content'], name: response['name'] }
      @collected_data << file_data
    end

    def match_regex?(file_name)
      file_name =~ /(.rb)$/
    end
  end
end
