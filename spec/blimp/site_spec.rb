require 'spec_helper'
require 'rack/test'

describe Site do
  include Rack::Test::Methods

  let(:source) { Blimp::Sources::FakeSource.new({
    "index.html" => "<h1>Hello world!</h1>",
    "templates" => { "layout.liquid" => "{{ content }}" }
  }) }
  let(:site) { Site.new("my-site", source) }
  def app; site; end

  it "should be initializable" do
    site.should be
  end

  describe "config" do
    it "should read the config if file exists" do
      source = stub
      source.should_receive(:get_file).with("/_blimp.yaml").and_return(SourceFile.new("/_blimp.yaml", ""))
      Site.new("my-site", source)
    end

    it "should raise if the config file is invalid" do
      source = Blimp::Sources::FakeSource.new({ "_blimp.yaml" => "key: @value" })
      expect {
        site = Site.new("my-site", source)
      }.to raise_error(Site::InvalidConfig)
    end

    it "should work if the config file does not exist" do
      source = stub
      source.should_receive(:get_file).with("/_blimp.yaml").and_raise(SourceFile::NotFound)
      Site.new("my-site", source)
    end
  end

  describe "#call" do
    it "should return a response for existing URLs" do
      get "/index.html"
      last_response.should be_ok
    end

    it "should return 404 for URLs that are matched by a handler but don't exist" do
      get "/nonexistent.html"
      last_response.should_not be_ok
    end

    context "without any handlers" do
      def app
        Site.new("my-site", source, :config => {:handlers => [{:path => "/", :handler => []}]})
      end

      it "should raise for all URLs" do
        get "/"
        last_response.should_not be_ok
      end
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
