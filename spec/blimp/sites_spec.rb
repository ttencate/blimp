require "spec_helper"

describe Sites do
  let(:source) { Blimp::Sources::FakeSource.new({ "templates" => { "layout.liquid" => "{{ content }}" } }) }
  let(:domain) { "example.com" }
  let(:site) { Site.new("my-site", source, domains: [domain]) }

  describe ".add" do
    it "remembers a site" do
      Sites.add(site)
      Sites.all.should == [site]
    end
  end

  describe ".all" do
    it "returns all known sites" do
      site = stub
      Sites.instance_eval { self.sites = [site] }
      Sites.all.should == [site]
    end
  end

  describe ".find_by_domain" do
    it "finds a site with a single domain" do
      Sites.add(site)
      Sites.find_by_domain(domain).should == site
    end
  end

  describe ".clear" do
    it 'clears all known sites' do
      Sites.add(site)
      Sites.clear
      Sites.all.should be_empty
    end
  end
end

