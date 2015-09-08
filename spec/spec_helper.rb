$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gh_fasterer'

class StubbedResponse
  def code
    200
  end
end
