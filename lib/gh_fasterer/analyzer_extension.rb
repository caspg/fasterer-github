require 'fasterer'
require 'base64'

module GhFasterer
  class AnalyzerExtension < Fasterer::Analyzer
    def initialize(content64)
      @content64 = content64
      @file_content = decoded_content
    end

    def scan
      super
    end

    def errors
      super
    end

    def offences
      offences = {}
      errors.group_by(&:name).each do |k, v|
        offences[k] = v.map(&:line_number)
      end
      offences
    end

    private

    attr_reader :content64

    def decoded_content
      Base64.decode64(content64)
    end
  end
end
