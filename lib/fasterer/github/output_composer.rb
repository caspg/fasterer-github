module Fasterer
  module Github
    class OutputComposer
      def initialize(owner, repo)
        @repo_owner = owner
        @repo_name = repo
      end

      def add_offences(offences, path)
        offences.each do |offence_name, lines|
          details = { path: path, lines: lines }
          (fasterer_offences[offence_name] ||= []) << details
        end
      end

      def add_errors(path)
        errors << { path: path }
      end

      def add_api_errors(new_api_errors)
        new_api_errors.each { |e| api_errors << e }
      end

      def result
        {
          repo_owner: repo_owner,
          repo_name: repo_name,
          fasterer_offences: fasterer_offences,
          errors: errors,
          api_errors: api_errors
        }
      end

      private

      attr_accessor :repo_owner, :repo_name

      def fasterer_offences
        @fasterer_offenses ||= {}
      end

      def errors
        @errors ||= []
      end

      def api_errors
        @api_errors ||= []
      end
    end
  end
end
