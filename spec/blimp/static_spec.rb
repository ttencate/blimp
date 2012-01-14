require "spec_helper"

describe Static do
  describe "#from_path" do
    let(:source) { Blimp::Sources::FakeSource.new({ "image.jpg" => "This is not a real JPEG" }) }
    let(:static) { Static.from_path("/image.jpg", source) }

    context "for a nonexistent file" do
      it "should raise" do
        expect {
          Static.from_path("/nonexistent.jpg", source)
        }.to raise_error(Static::NotFound)
      end
    end

    context "for a JPG file" do
      it "should be image/jpeg" do
        static.mimetype.should == "image/jpeg"
      end

      it "should serve its contents verbatim" do
        static.contents.should == "This is not a real JPEG"
      end
    end
  end
end
