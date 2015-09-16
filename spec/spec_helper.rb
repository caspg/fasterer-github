$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gh_fasterer'
require 'webmock/rspec'
require 'vcr'
require 'pry'

class StubbedResponse
  def code
    200
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
