require "spec_helper"

describe Page do
  describe "#from_path" do
    context "for raw HTML files" do
      let(:source) { Blimp::Sources::MockSource.new({ "index.html" => "This is my homepage" }) }
      let(:page) { Page.from_path("/index.html", source) }

      it "should have a body" do
        page.stub(:render_layout? => false)
        page.body.should == "This is my homepage"
      end

      it "should have headers" do
        page.headers.should == {"Content-Type" => "text/html"}
      end
    end

    context "for markdown files" do
      let(:source) { Blimp::Sources::MockSource.new({ "index.html.markdown" => "# This is my homepage" }) }
      let(:page) { Page.from_path("/index.html", source) }

      it "renders as markdown" do
        Blimp::Renderer.should_receive(:render).with("# This is my homepage", "text/markdown").once
        page
      end

      it "should have a body" do
        page.stub(:render_layout? => false)
        page.body.should == "<h1 id='this_is_my_homepage'>This is my homepage</h1>"
      end

      it "should have headers" do
        page.headers.should == {"Content-Type" => "text/html"}
      end
    end

    context "for a JPG file" do
      let(:source) { Blimp::Sources::MockSource.new({ "image.jpg" => "This is not a real JPEG" }) }
      let(:page) { Page.from_path("/image.jpg", source) }

      it "should be image/jpeg" do
        page.headers["Content-Type"].should == "image/jpeg"
      end
    end
  end
end
