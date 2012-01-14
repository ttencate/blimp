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
      FileUtils.mkdir("/root/.hidden_dir")
      File.open("/root/subdir/file.html", "w") {|f| f.print("File contents") }
      File.open("/root/empty.html", "w")
      File.open("/root/.hidden_file", "w")
    end

    after do
      FakeFS.deactivate!
      FakeFS::FileSystem.clear
    end

    it "should not show hidden directories" do
      source.is_dir?("/.hidden_dir").should be_false
    end

    it "should not allow access to hidden directories" do
      expect {
        source.get_dir("/.hidden_dir")
      }.to raise_error(SourceDir::NotFound)
    end

    it "should not show hidden files" do
      source.is_file?("/.hidden_file").should be_false
    end

    it "should not allow access to hidden files" do
      expect {
        source.get_file("/.hidden_file")
      }.to raise_error(SourceFile::NotFound)
    end
  end
end
