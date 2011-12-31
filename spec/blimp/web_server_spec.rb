require 'spec_helper'
require 'rack/test'
require 'cgi'

describe Blimp::WebServer do
  include Rack::Test::Methods

  def app
    Blimp::WebServer
  end

  it "should respond for a known page" do
    get "/index.html"
    last_response.should be_ok
  end
end
