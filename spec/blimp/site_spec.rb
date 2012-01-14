require "spec_helper"

describe Site do
  let(:source) { stub }
  let(:site) { Site.new("my-site", source) }

  before { source.stub(:get_file).with("/templates/layout.liquid").and_return(stub(:contents => "{{ content }}")) }

  it "should be initializable" do
    site.should be
  end

  describe ".add" do
    it 'remembers a site' do
      Site.add(site)
      Site.all.should == [site]
    end
  end

  describe ".find_by_domain" do
    it 'finds a site with a single domain' do
      domain = "example.com"
      site = Site.new("my-site", source, domains: [domain])
      Site.add(site)
      Site.find_by_domain(domain).should == site
    end
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
