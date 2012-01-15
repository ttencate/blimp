require 'spec_helper'
require 'rack/test'

describe Blimp::Handlers::StaticHandler do
  include Rack::Test::Methods

  let(:source) { Blimp::Sources::FakeSource.new({ "image.jpg" => "A kitten" }) }
  let(:theme) { stub }
  let(:handler) { Blimp::Handlers::StaticHandler.new("/", source, theme) }
  def app; handler; end

  describe "#handle" do
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
end
