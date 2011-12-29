require "spec_helper"

describe SourceDir do
  let(:dir) { SourceDir.new("/foo") }
  let(:dir_with_entries) { SourceDir.new("/bar", ["f:/bar/about.markdown", "f:/bar/index.markdown"]) }
  let(:redis) { MockRedis.new }

  it "should remember its name" do
    dir.path.should == "/foo"
  end

  it "should not accept non-absolute paths" do
    expect {
      SourceDir.new("relative_path")
    }.to raise_error(ArgumentError)
  end

  it "should have entries" do
    entry1 = stub
    entry2 = stub
    dir.entries << entry1 << entry2
    dir.entries.should == [entry1, entry2]
  end

  it "should generate its key" do
    dir.key.should == "d:/foo"
  end

  it "should generate keys from paths" do
    SourceDir.key("/foo").should == "d:/foo"
  end

  describe "persistence" do
    it "should be savable with entries" do
      dir_with_entries.save_to(redis)
      redis.get(dir_with_entries.key).should be
    end

    it "should be savable without entries" do
      dir.save_to(redis)
      redis.get(dir.key).should be
    end

    it "should be retrievable with entries" do
      dir_with_entries.save_to(redis)
      SourceDir.load_from(redis, dir_with_entries.path).should == dir_with_entries
    end

    it "should be retrievable without entries" do
      dir.save_to(redis)
      SourceDir.load_from(redis, dir.path).should == dir
    end

    it "should raise if not in redis" do
      expect { 
        SourceDir.load_from(redis, "/unknown")
      }.to raise_error(SourceDir::NotFound)
    end
  end
end
