require "spec_helper"

describe SourceFile do
  let(:file) { SourceFile.new("/foo.markdown") }
  let(:redis) { MockRedis.new }

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

  describe "persistence" do
    context "with contents" do
      before { file.contents = "Foo" } 

      it "should be savable" do
        file.save_to(redis).should be_true
      end

      it "should be retrievable" do
        file.save_to(redis)
        SourceFile.load_from(redis, file.path).should == file
      end
    end
    
    context "without contents" do
      it "should be savable" do
        file.save_to(redis).should be_true
      end

      it "should be retrievable" do
        file.save_to(redis)
        SourceFile.load_from(redis, file.path).should == file
      end
    end

    it "should raise if not in redis" do
      expect { 
        SourceFile.load_from(redis, "/unknown")
      }.to raise_error(SourceFile::NotFound)
    end
  end
end
