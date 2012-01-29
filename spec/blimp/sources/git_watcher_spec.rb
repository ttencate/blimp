require 'spec_helper'

describe Blimp::Sources::GitWatcher do
  include_context "git repositories"

  let(:push_source_repo) { Dir.mktmpdir("push_source_repo") }
  let(:git_source) { double("git_source") }

  before do
    git_source.stub(:path) { @git_path }.any_number_of_times
    git_source.stub(:head_path) { File.join(@git_path, "refs/heads/master") }.any_number_of_times
  end

  before(:all) do
    Dir.chdir(push_source_repo) {|path|
      git("clone", normal_repo, ".")
      File.open("added_file", "w") {|f| f.puts("This file was added") }
      git("add", "-A")
      git("commit", "-mCommit to be pushed")
    }
    Dir.chdir(normal_repo) {|path|
      git("config", "receive.denyCurrentBranch", "ignore")
    }
  end

  after(:all) do
    FileUtils.remove_entry_secure(push_source_repo)
  end

  shared_examples "a git repo watcher" do
    before do
      # Create a new instance each time because we change the state
      @watcher = Blimp::Sources::GitWatcher.new
    end

    describe "#watch" do
      it "takes a GitSource and a block" do
        @watcher.watch(git_source) { }
      end
    end

    describe "#process" do
      it "calls the watch block when head is changed" do
        @watcher.watch(git_source) {
          throw :block_called
        }
        Dir.chdir(push_source_repo) {|path|
          git("push", @repo_path)
        }
        @watcher.process.should throw(:block_called) # will block forever if the test is broken...
      end
    end
  end

  context "when watching a non-bare repo" do
    before do
      @repo_path = normal_repo
      @git_path = File.join(@repo_path, ".git")
    end
    it_should_behave_like "a git repo watcher"
  end

  context "when watching a bare repo" do
    before do
      @repo_path = bare_repo
      @git_path = @repo_path
    end
    it_should_behave_like "a git repo watcher"
  end
end
