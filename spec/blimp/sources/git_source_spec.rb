require "spec_helper"

describe Blimp::Sources::GitSource do
  let(:normal_repo) { Dir.mktmpdir("normal_repo") }
  let(:bare_repo) { Dir.mktmpdir("bare_repo") }

  def git(*args)
    system("git", *args, STDOUT => "/dev/null") or raise "git failed: #{$?}"
  end

  before(:all) do
    Dir.chdir(normal_repo) {|path|
      git("init")
      FileUtils.mkdir("subdir")
      FileUtils.mkdir("empty")
      FileUtils.mkdir(".hidden_dir")
      File.open("subdir/file.html", "w") {|f| f.print("File contents") }
      File.open("empty/.gitkeep", "w")
      File.open("empty.html", "w")
      File.open(".hidden_file", "w")
      git("add", "-A")
      git("commit", "-mTest commit")
    }

    Dir.chdir(bare_repo) {|path|
      git("clone", "--bare", normal_repo, ".")
    }
  end

  after(:all) do
    # TODO these don't work
    FileUtil.remove_entry_secure(normal_repo)
    FileUtil.remove_entry_secure(bare_repo)
  end

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
  end
end
