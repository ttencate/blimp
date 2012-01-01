require "spec_helper"

describe Site do
  let(:source) { stub }
  let(:site) { Site.new("my-site", source) }

  it "should be initializable" do
    site.should be
  end

  describe "config" do
    it "should have a config if file exists"
    it "should have an empty config if file does not exist"
  end

  describe "#find_page" do
    it "should find a page" do
      path = stub
      page = stub
      Page.stub(:from_path).with(path, source) { page }
      site.find_page(path).should == page
    end
  end

  describe "#render_page" do
    it "should render a page" do
      page = stub
      page.stub!(:body).and_return("Page contents")
      site.render_page(page).should include("Page contents")
    end
  end
end
