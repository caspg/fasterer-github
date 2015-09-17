require 'fasterer'
require 'base64'

module GhFasterer
  class AnalyzerExtension < Fasterer::Analyzer
    def initialize(content64)
      @content64 = content64
      @file_content = decoded_content
    end

    private

    attr_reader :content64

    def decoded_content
      Base64.decode64(content64)
    end
  end
end
