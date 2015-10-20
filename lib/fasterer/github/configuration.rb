module Fasterer
  module Github
    class << self
      attr_accessor :configuration
    end

    def self.configure
      yield(configuration)
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset_configuration
      Fasterer::Github.configuration = nil
      Fasterer::Github.configure {}
    end

    class Configuration
      attr_accessor :client_id, :client_secret, :access_token

      def initialize
        @client_id = nil
        @client_secret = nil
        @access_token = nil
      end
    end
  end
end
