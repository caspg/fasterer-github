module GhFasterer
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
    GhFasterer.configuration = nil
    GhFasterer.configure {}
  end

  class Configuration
    attr_accessor :client_id, :client_secret

    def initialize
      @client_id = nil
      @client_secret = nil
    end
  end
end
