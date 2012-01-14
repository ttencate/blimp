require 'spec_helper'
require 'rack/test'
require 'cgi'

describe Blimp::WebServer do
  include Rack::Test::Methods

  def app
    Blimp::WebServer
  end

  before do
    sample_root = Blimp.root.join("sample")
    sample_source = Blimp::Sources::DiskSource.new(sample_root)
    sample_site = Site.new("sample", sample_source, domains: ["example.org"])
    Site.add(sample_site)
  end

  after do
    Site.clear
  end

  it "should respond for a known page" do
    get "/index.html"
    last_response.should be_ok
  end
end
