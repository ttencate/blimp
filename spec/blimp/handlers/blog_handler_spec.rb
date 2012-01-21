require 'spec_helper'
require 'rack/test'

describe Blimp::Handlers::BlogHandler do
  include Rack::Test::Methods

  let(:source) { Blimp::Sources::FakeSource.new({
    "blog" => {
      "2012-01-21-paint-just-applied.html" => "I have just applied the paint",
      "2012-01-21-paint-just-applied.jpg" => "Not a real JPEG"
    },
    "_theme" => {
      "layout.liquid" => "<html><body>{{ content }}</body></html>"
    },
  }) }
  let(:theme) { Theme.new(source, "/_theme") }
  let(:handler) {
    Blimp::Handlers::BlogHandler.any_instance.stub(:source).and_return(source)
    Blimp::Handlers::BlogHandler.any_instance.stub(:theme).and_return(theme)
    Blimp::Handlers::BlogHandler.new("/")
  }
  def app; handler; end

  describe "GET /blog/2012/01/21/paint-just-applied.html" do
    it "returns a single blog page" do
      get "/blog/2012/01/21/paint-just-applied.html"
      last_response.body.should include("I have just applied the paint")
    end
  end

  context "for URLs that it cannot handle" do
    it "should raise" do
      expect {
        get "/image.jpg"
      }.to raise_error(Blimp::Handler::CantTouchThis)
    end
  end
end

