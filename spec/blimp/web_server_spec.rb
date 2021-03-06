require 'spec_helper'
require 'rack/test'
require 'cgi'

describe Blimp::WebServer do
  include Rack::Test::Methods

  def app
    Blimp::WebServer.new
  end

  before do
    sample_root = Blimp.gem_root.join("sample")
    sample_source = Blimp::Sources::DiskSource.new(sample_root)
    sample_site = Site.new("sample", sample_source, domains: ["example.org"])
    Sites.add(sample_site)
  end

  it "should respond for a known page" do
    get "/index.html"
    last_response.should be_ok
  end

  it "should not respond for an unknown page" do
    get "/unknown.html"
    last_response.should_not be_ok
  end
end
