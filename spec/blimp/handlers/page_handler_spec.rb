require 'spec_helper'

describe Blimp::Handlers::PageHandler do
  let(:source) { Blimp::Sources::FakeSource.new({
    "index.html" => "<h1>My site's _index_</h1>",
    "page.html.markdown" => "* My list",
    "_theme" => {
      "layout.liquid" => "<html><body>{{ content }}</body></html>"
    },
  }) }
  let(:theme) { Theme.new(source, "/_theme") }
  let(:handler) { Blimp::Handlers::PageHandler.new("/") }

  shared_examples_for "pages of all input types" do
    it "returns headers" do
      headers.should be_a(Hash)
    end

    it "returns a content type of text/html" do
      headers["Content-Type"].should == "text/html"
    end

    it "renders using the template" do
      body.should include("<html><body>")
    end
  end

  describe "#handle" do
    context "for HTML files" do
      let(:response) { handler.handle(source, theme, "/index.html") }
      let(:headers) { response[0] }
      let(:body)    { response[1] }

      it_behaves_like "pages of all input types"

      it "returns the contents of HTML files" do
        body.should include("<h1>My site's _index_</h1>")
      end
    end

    context "for Markdown files" do
      let(:response) { handler.handle(source, theme, "/page.html.markdown") }
      let(:headers) { response[0] }
      let(:body)    { response[1] }

      it_behaves_like "pages of all input types"

      it "returns the rendered contents of Markdown files" do
        body.should include("<li>My list</li>")
      end
    end
  end
end
