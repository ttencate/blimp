require "spec_helper"

describe Blimp::Sources::MockSource do
  describe "#initialize" do
    it "should take a hash of files and directories" do
      source = Blimp::Sources::MockSource.new({})
    end
  end

  it_behaves_like "a source" do
    let(:source) {
      Blimp::Sources::MockSource.new({
        "empty" => {},
        "empty.html" => "",
        "subdir" => {
          "file.html" => "File contents"
        }
      })
    }
  end
end
