require 'spec_helper'
require 'rack/test'

describe Blimp::Handlers::StaticHandler do
  include Rack::Test::Methods

  let(:source) { Blimp::Sources::FakeSource.new({ "image.jpg" => "A kitten" }) }
  let(:handler) {
    Blimp::Handlers::StaticHandler.any_instance.stub(:source).and_return(source)
    Blimp::Handlers::StaticHandler.new("/")
  }

  def app; handler; end

  context "for existing files" do
    before do
      get "/image.jpg"
    end

    it "returns the contents for the path" do
      last_response.body.should == "A kitten"
    end

    it "returns a content type" do
      last_response.headers["Content-Type"].should == "image/jpeg"
    end
  end

  context "for nonexistent files" do
    before do
      get "/nonexistent.jpg"
    end

    it "should return 404" do
      last_response.status.should == 404
    end
  end
end
