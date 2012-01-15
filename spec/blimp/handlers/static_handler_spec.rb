require 'spec_helper'

describe Blimp::Handlers::StaticHandler do
  let(:source) { Blimp::Sources::FakeSource.new({ "image.jpg" => "A kitten" }) }
  let(:handler) { Blimp::Handlers::StaticHandler.new("/") }

  describe "#handle" do
    let(:headers) { handler.handle(source, "/image.jpg")[0] }
    let(:body)    { handler.handle(source, "/image.jpg")[1] }

    it "returns the contents for the path" do
      body.should == "A kitten"
    end

    it "returns headers" do
      headers.should be_a(Hash)
    end

    it "returns a content type" do
      headers["Content-Type"].should == "image/jpeg"
    end
  end
end
