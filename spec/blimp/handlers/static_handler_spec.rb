require 'spec_helper'

describe Blimp::Handlers::StaticHandler do
  let(:source) { Blimp::Sources::FakeSource.new({ "image.jpg" => "A kitten" }) }
  let(:theme) { stub }
  let(:handler) { Blimp::Handlers::StaticHandler.new("/") }

  describe "#handle" do
    context "for existing files" do
      let(:headers) { handler.handle(source, theme, "/image.jpg")[0] }
      let(:body)    { handler.handle(source, theme, "/image.jpg")[1] }

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

    context "for nonexistent files" do
      it "should raise" do
        expect {
          handler.handle(source, theme, "/nonexistent.jpg")
        }.to raise_error(Blimp::Handler::SourceNotFound)
      end
    end
  end
end
