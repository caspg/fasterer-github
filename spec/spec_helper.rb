$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['TRAVIS']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'fasterer/github'
require 'webmock/rspec'
require 'vcr'
require 'pry'

def RSpec.root
  @root_path = Pathname.new(File.dirname(__FILE__))
end

Dir[RSpec.root.join('support/**/*.rb')].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_hosts 'codeclimate.com'
end

WebMock.disable_net_connect!(:allow => 'codeclimate.com')

class SuccessResponse
  def code
    200
  end
end

class RateLimitResponse
  def code
    403
  end

  def body
    "{\"message\":\"API rate limit exceeded for 88.156.131.117. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)\",\"documentation_url\":\"https://developer.github.com/v3/#rate-limiting\"}"
  end
end

class ErorrResponse
  def code
    404
  end
end
