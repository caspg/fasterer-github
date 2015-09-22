module GhFasterer
  class OutputComposer
    def add_offences(offences, url, file_name)
      offences.each do |offence_name, lines|
        details = { file_name: file_name, url: url, lines: lines }
        (fasterer_offences[offence_name] ||= []) << details
      end
    end

    def add_errors
    end

    def result
      {
        fasterer_offences: fasterer_offences
      }
    end

    private

    def fasterer_offences
      @fasterer_offenses ||= {}
    end
  end
end
