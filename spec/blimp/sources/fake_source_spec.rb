require "spec_helper"

describe Blimp::Sources::FakeSource do
  describe "#initialize" do
    it "should take a hash of files and directories" do
      source = Blimp::Sources::FakeSource.new({})
    end
  end

  it_behaves_like "a source" do
    let(:source) {
      Blimp::Sources::FakeSource.new({
        "empty" => {},
        "empty.html" => "",
        "subdir" => {
          "file.html" => "File contents",
          "bounce.html.markdown" => "Markdown contents"
        }
      })
    }
  end
end
