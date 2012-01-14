require "spec_helper"

describe Site do
  let(:source) { Blimp::Sources::FakeSource.new({ "templates" => { "layout.liquid" => "{{ content }}" } }) }
  let(:site) { Site.new("my-site", source) }

  it "should be initializable" do
    site.should be
  end

  describe ".add" do
    it "remembers a site" do
      Site.add(site)
      Site.all.should == [site]
    end
  end

  describe ".find_by_domain" do
    it "finds a site with a single domain" do
      domain = "example.com"
      site = Site.new("my-site", source, domains: [domain])
      Site.add(site)
      Site.find_by_domain(domain).should == site
    end
  end

  describe "config" do
    it "should have a config if file exists" do
      source = Blimp::Sources::FakeSource.new(
        { "_blimp.yaml" => "handlers:\n- path: /\n  handler: static\n- path: /blog\n  handler: blog" })
      site = Site.new("my-site", source)
      site.handlers.should == [
        {"path" => "/", "handler" => "static"},
        {"path" => "/blog", "handler" => "blog"}]
    end

    it "should raise if the config file is invalid" do
      source = Blimp::Sources::FakeSource.new({ "_blimp.yaml" => "key: @value" })
      expect {
        site = Site.new("my-site", source)
      }.to raise_error(Site::InvalidConfig)
    end

    it "should have a default config if config file does not exist" do
      site.handlers.should == []
    end
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

  describe "#domains" do
    it "returns the domains" do
      domains = ["test"]
      site = Site.new("my-site", source, :domains => domains)
      site.domains.should == domains
    end

    it "returns an empty array if none given" do
      Site.new("my-site", source).domains.should == []
    end
  end

  describe "#has_domain?" do
    let(:site) { Site.new("my-site", source, domains: ["example.com"]) }

    it "returns true if the domain is literally in the domains list" do
      site.has_domain?("example.com").should be_true   
    end

    it "is not true for unspecified domains" do
      site.has_domain?("google.com").should be_false
    end
  end
end
