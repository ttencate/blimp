require "spec_helper"

describe Site do
  let(:source) { Blimp::Sources::FakeSource.new({ "templates" => { "layout.liquid" => "{{ content }}" } }) }
  let(:site) { Site.new("my-site", source) }

  it "should be initializable" do
    site.should be
  end

  describe "config" do
    it "should read the config if file exists" do
      pending "TODO: stub the source and check that the config is being read"
    end

    it "should raise if the config file is invalid" do
      source = Blimp::Sources::FakeSource.new({ "_blimp.yaml" => "key: @value" })
      expect {
        site = Site.new("my-site", source)
      }.to raise_error(Site::InvalidConfig)
    end

    it "should work if the config file does not exist" do
      pending "TODO: stub the source and check that it attempts to read the config"
    end
  end

  describe "#get_handler" do
    context "without any handlers configured" do
      let(:source) { Blimp::Sources::FakeSource.new({ "_blimp.yaml" => "handlers:" }) }
      let(:site) { Site.new("my-site", source) }

      it "should return the default handlers for the root" do
        site.handlers_for_path("/").should have_types([Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler])
      end

      it "should return the default handlers for a subdir" do
        site.handlers_for_path("/subdir").should have_types([Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler])
      end
    end

    context "with some handlers configured" do
      let(:source) { Blimp::Sources::FakeSource.new(
        { "_blimp.yaml" => "handlers:\n- path: /\n  handler: static\n- path: /page\n  handler: page" }) }
      let(:site) { Site.new("my-site", source) }

      it "should return handlers for the root" do
        site.handlers_for_path("/").should have_types([Blimp::Handlers::StaticHandler])
      end

      it "should return configured handlers for subdirectories" do
        site.handlers_for_path("/page").should have_types([Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler])
      end

      it "should fall back the handler of parent directories" do
        site.handlers_for_path("/foo").should have_types([Blimp::Handlers::StaticHandler])
        site.handlers_for_path("/page/foo").should have_types([Blimp::Handlers::PageHandler, Blimp::Handlers::StaticHandler])
      end

      it "should not match prefixes incorrectly" do
        site.handlers_for_path("/page_with_suffix").should have_types([Blimp::Handlers::StaticHandler])
      end
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
