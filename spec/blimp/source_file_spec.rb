require "spec_helper"

describe SourceFile do
  let(:file) { SourceFile.new("/foo.markdown") }

  it "should remember its name" do
    file.path.should == "/foo.markdown"
  end

  it "should not accept non-absolute paths" do
    expect {
      SourceFile.new("relative_path")
    }.to raise_error(ArgumentError)
  end

  it "should have contents" do
    contents = "Some content"
    file.contents = contents
    file.contents.should == contents
  end
end
