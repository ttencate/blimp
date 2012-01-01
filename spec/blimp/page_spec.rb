require "spec_helper"

describe Page do
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

  context "for a JPG file" do
    let(:source) { Blimp::Sources::MockSource.new({ "image.jpg" => "This is not a real JPEG" }) }
    let(:page) { Page.from_path("/image.jpg", source) }

    it "should be image/jpeg" do
      page.headers["Content-Type"].should == "image/jpeg"
    end
  end

end
