require "spec_helper"

describe Site do
  let(:redis) { MockRedis.new }
  let(:source) { stub }
  let(:site) { Site.new("my-site", source, redis) }

  it "should be initializable" do
    site.should be
  end

  describe "config" do
    it "should have a config if file exists"
    it "should have an empty config if file does not exist"
  end

  describe "#layout" do
    it "should have a layout" do
      layout = "<!DOCTYPE html>"
      File.stub(:read).with(File.join(site.send(:templates_path), "layout.liquid")) { layout }
      site.layout.should be_a(Liquid::Template)
    end
  end

  describe "#find_page" do
    it "should find a page" do
      path = stub
      page = stub
      Page.stub(:from_path).with(path, redis, site) { page }
      site.find_page(path).should == page
    end
  end
end
