require "spec_helper"

describe Site do
  let(:root) { stub(:to_path => "/") }
  let(:site) { Site.new(root) }

  describe Config do
    it "should load from YAML" do
      path = stub
      YAML.should_receive(:load).with(path).and_return(Hash.new)
      Site::Config.load(path)
    end
  end

  it "should be initializable" do
    Site.new("/site").should be
  end

  it "should have a config" do
    config = stub
    Site::Config.stub(:load).with(File.join(root, ".config.yml")) { config } 
    site.config.should == config
  end

  it "should have a templates path" do
    site.templates_path.should == File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "templates"))
  end

  describe "#layout" do
    it "should have a layout" do
      layout = "<!DOCTYPE html>"
      File.stub(:read).with(File.join(site.templates_path, "layout.liquid")) { layout }
      site.layout.should be_a(Liquid::Template)
    end
  end
end
