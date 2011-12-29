require "spec_helper"

describe Page do
  let(:redis) { MockRedis.new }

  context "for raw HTML files" do
    before do
      source_file = SourceFile.new("/index.html", "This is my homepage")
      source_file.save_to(redis)
    end

    let(:page) { Page.from_path("/index.html", redis) }

    it "should have a body" do
      page.body.should == "This is my homepage"
    end

    it "should have headers" do
      page.headers.should == {"Content-Type" => "text/html"}
    end
  end

  context "for a JPG file" do
    before do
      source_file = SourceFile.new("/image.jpg", "This is not a real JPEG")
      source_file.save_to(redis)
    end

    let(:page) { Page.from_path("/image.jpg", redis) }

    it "should be image/jpeg" do
      page.headers["Content-Type"].should == "image/jpeg"
    end
  end

end
