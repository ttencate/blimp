require "spec_helper"

describe FileSystemSyncer do
  before do
    FakeFS.activate!
    FileUtils.mkdir("/empty")
    FileUtils.mkdir("/simple")
    FileUtils.mkdir("/simple/subdir")
    File.open("/simple/index.markdown", "w") {|f| f.print "Contents!" }
  end

  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
  end

  let(:redis) { MockRedis.new }

  it "should raise for a nonexistent root" do
    expect {
      FileSystemSyncer.new("/doesnotexist")
    }.to raise_error(ArgumentError)
  end

  it "should add a source dir for the root" do
    syncer = FileSystemSyncer.new("/empty", redis)
    source_dir = stub
    source_dir.should_receive(:save_to).with(redis)
    SourceDir.stub(:new).with("/") { source_dir }
    syncer.sync!
  end

  it "should sync subdirs" do
    syncer = FileSystemSyncer.new("/simple", redis)
    syncer.sync!
    SourceDir.load_from(redis, "/").entries.should include("d:/subdir")
  end

  it "should sync files" do
    syncer = FileSystemSyncer.new("/simple", redis)
    syncer.sync!
    SourceFile.load_from(redis, "/index.markdown").contents.should == "Contents!"
  end

end
