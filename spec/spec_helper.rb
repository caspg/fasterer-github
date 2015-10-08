$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gh_fasterer'
require 'webmock/rspec'
require 'vcr'
require 'pry'

def RSpec.root
  @root_path = Pathname.new(File.dirname(__FILE__))
end

Dir[RSpec.root.join('support/**/*.rb')].each { |f| require f }

class StubbedResponse
  def code
    200
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
