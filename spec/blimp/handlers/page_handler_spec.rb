require 'spec_helper'
require 'rack/test'

describe Blimp::Handlers::PageHandler do
  include Rack::Test::Methods

  let(:source) { Blimp::Sources::FakeSource.new({
    "index.html" => "<h1>My site's _index_</h1>",
    "page.html.markdown" => "* My list",
    "image.jpg" => "Not a real JPEG",
    "_theme" => {
      "layout.liquid" => "<html><body>{{ content }}</body></html>"
    },
  }) }
  let(:theme) { Theme.new(source, "/_theme") }
  let(:handler) {
    handler = Blimp::Handlers::PageHandler.new("/")
    handler.stub(:source).and_return(source)
    handler.stub(:theme).and_return(theme)
    handler
  }
  def app; handler; end

  shared_examples_for "pages of all input types" do
    it "returns a content type of text/html" do
      last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
    end

    it "renders using the template" do
      last_response.body.should include("<html><body>")
    end
  end

  context "for HTML files" do
    before do
      get "/index.html"
    end

    it_behaves_like "pages of all input types"

    it "returns the contents of HTML files" do
      last_response.body.should include("<h1>My site's _index_</h1>")
    end
  end

  context "for Markdown files" do
    before do
      get "/page.html.markdown"
    end

    it_behaves_like "pages of all input types"

    it "returns the rendered contents of Markdown files" do
      last_response.body.should include("<li>My list</li>")
    end
  end

  context "for a handlable URL whose file does not exist" do
    before do
      get "/nonexistent.html"
    end

    it "should return a 404 response" do
      last_response.status.should == 404
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
