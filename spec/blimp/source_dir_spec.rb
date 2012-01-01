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
end
