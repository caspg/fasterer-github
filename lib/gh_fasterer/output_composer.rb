module GhFasterer
  class OutputComposer
    def add_offences(offences, url, file_name)
      offences.each do |offence_name, lines|
        details = { file_name: file_name, url: url, lines: lines }
        (fasterer_offences[offence_name] ||= []) << details
      end
    end

    def add_errors(url, file_name)
      errors << { url: url, file_name: file_name }
    end

    def result
      {
        fasterer_offences: fasterer_offences,
        errors: errors
      }
    end

    private

    def fasterer_offences
      @fasterer_offenses ||= {}
    end

    def errors
      @errors ||= []
    end
  end
end
