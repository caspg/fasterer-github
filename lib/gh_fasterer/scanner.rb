require 'gh_fasterer/gh_traverser'
require 'gh_fasterer/output_composer'

module GhFasterer
  class Scanner
    def initialize(owner, repo, path)
      @owner = owner
      @repo = repo
      @path = path
    end

    def run
      data = traverse_and_collect_data
      data.each { |d| analyze_code(d) }
    end

    def result
      output_composer.result
    end

    private

    attr_reader :owner, :repo, :path

    def traverser
      @traverser ||= GhFasterer::GhTraverser.new(owner, repo, path)
    end

    def output_composer
      @output_composer ||= GhFasterer::OutputComposer.new
    end

    def traverse_and_collect_data
      traverser.traverse
      traverser.collected_data
    end

    def analyze_code(data)
      analyzer = GhFasterer::AnalyzerExtension.new(data[:content64])
      analyzer.scan
    rescue RubyParser::SyntaxError, Racc::ParseError, Timeout::Error
      output_composer.add_errors(data[:url], data[:name])
    else
      output_composer.add_offences(analyzer.offences, data[:url], data[:name])
    end
  end
end
