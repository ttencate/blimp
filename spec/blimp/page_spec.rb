require "spec_helper"

describe Page do
  describe "#from_path" do
    context "for raw HTML files" do
      let(:source) { Blimp::Sources::FakeSource.new({ "index.html" => "This is my homepage" }) }
      let(:page) { Page.from_path("/index.html", source) }

      it "should have a body" do
        page.stub(:render_layout? => false)
        page.body.should == "This is my homepage"
      end
    end

    context "for markdown files" do
      let(:source) { Blimp::Sources::FakeSource.new({ "index.html.markdown" => "# This is my homepage" }) }
      let(:page) { Page.from_path("/index.html", source) }

      it "renders as markdown" do
        Blimp::Renderer.should_receive(:render).with("# This is my homepage", "text/markdown").once
        page
      end

      it "should have a body" do
        page.stub(:render_layout? => false)
        page.body.should == "<h1 id=\"this-is-my-homepage\">This is my homepage</h1>\n"
      end
    end
  end
end
