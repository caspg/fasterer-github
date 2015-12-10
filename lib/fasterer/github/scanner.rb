require 'fasterer/github/gh_traverser'
require 'fasterer/github/output_composer'
require 'fasterer/github/analyzer_extension'

module Fasterer
  module Github
    class Scanner

      CONFIG_FILE_NAME = '.fasterer.yml'
      SPEEDUPS_KEY     = 'speedups'
      EXCLUDE_PATHS_KEY = 'exclude_paths'

      def initialize(owner, repo, path)
        @owner = owner
        @repo = repo
        @path = path
      end

      def run
        data = traverse_and_collect_data
        data.each { |d| analyze_code(d) }
      end

      def results
        output_composer.result
      end

      private

      attr_reader :owner, :repo, :path

      def traverser
        @traverser ||= Fasterer::Github::GhTraverser.new(owner, repo, path, ignored_paths)
      end

      def output_composer
        @output_composer ||= Fasterer::Github::OutputComposer.new(owner, repo, ignored_offences)
      end

      def traverse_and_collect_data
        traverser.traverse
        output_composer.add_api_errors(traverser.api_errors) if traverser.api_errors.any?
        traverser.collected_data
      end

      def analyze_code(data)
        analyzer = Fasterer::Github::AnalyzerExtension.new(data[:content64])
        analyzer.scan
      rescue RubyParser::SyntaxError, Racc::ParseError, Timeout::Error, RuntimeError
        output_composer.add_errors(data[:path])
      else
        output_composer.add_offences(analyzer.offences, data[:path])
      end

      def ignored_offences
        loaded_config_file[SPEEDUPS_KEY].select { |_, v| v == false }.keys.map(&:to_sym)
      end

      def ignored_paths
         loaded_config_file[EXCLUDE_PATHS_KEY]
      end

      def loaded_config_file
        @loaded_config_file ||= load_config_file
      end

      def load_config_file
        path_to_config = File.join(Dir.pwd, CONFIG_FILE_NAME)
        if File.exist?(path_to_config)
          empty_config_hash.merge!(YAML.load_file(path_to_config))
        else
          empty_config_hash
        end
      end

      def empty_config_hash
        { SPEEDUPS_KEY => {}, EXCLUDE_PATHS_KEY => [] }
      end
    end
  end
end
