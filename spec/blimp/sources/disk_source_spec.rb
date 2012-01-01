require "spec_helper"

describe Blimp::Sources::DiskSource do
  describe "#initialize" do
    it "should take a root path" do
      source = Blimp::Sources::DiskSource.new("/root")
      source.root.should == "/root"
    end
  end

  it_behaves_like "a source" do
    let(:source) { Blimp::Sources::DiskSource.new("/root") }

    before do
      FakeFS.activate!
      FileUtils.mkdir("/root")
      FileUtils.mkdir("/root/subdir")
      FileUtils.mkdir("/root/empty")
      File.open("/root/subdir/file.html", "w") {|f| f.print("File contents") }
      File.open("/root/empty.html", "w")
    end

    after do
      FakeFS.deactivate!
      FakeFS::FileSystem.clear
    end
  end
end
