require 'spec_helper'

describe Blimp::Sources::GitSource do
  include_context "git repositories"

  describe "#initialize" do
    it "should take a repo path" do
      source = Blimp::Sources::GitSource.new(normal_repo)
      source.root.should == normal_repo
    end

    it "should take a bare repo path" do
      source = Blimp::Sources::GitSource.new(bare_repo)
      source.root.should == bare_repo
    end

    it "should raise if the path does not contain a repo" do
      expect {
        Dir.mktmpdir("no_repo") {|no_repo|
          source = Blimp::Sources::GitSource.new(no_repo)
        }
      }.to raise_error(Blimp::Sources::GitSource::NoRepo)
    end

    it "should raise if the path does not exist" do
      expect {
        Dir.mktmpdir("empty_dir") {|empty_dir|
          source = Blimp::Sources::GitSource.new(File.join(empty_dir, "nonexistent"))
        }
      }.to raise_error(Blimp::Sources::GitSource::NoRepo)
    end
  end

  it_behaves_like "a source" do
    let(:source) { Blimp::Sources::GitSource.new(normal_repo) }

    it "should not show the .git directory" do
      source.is_dir?("/.git").should be_false
    end

    it "should not allow access to the .git directory" do
      expect {
        source.get_dir("/.git")
      }.to raise_error(SourceDir::NotFound)
    end

    describe "#path" do
      it "returns an absolute path" do
        source.path.should start_with("/")
      end

      it "returns the path of the .git directory" do
        File.exists?(File.join(source.path, "HEAD")).should be_true
      end
    end

    describe "#head_path" do
      it "returns a subdirectory of the repo" do
        source.head_path.should start_with(source.path)
      end

      it "points to a file containing a SHA1 hash" do
        contents = File.open(source.head_path, "r").read.chomp
        contents.should match(/[0-9a-f]{40}/)
      end
    end
  end
end
