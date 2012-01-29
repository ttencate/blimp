require 'spec_helper'

shared_context "git repositories" do
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
      File.open("subdir/bounce.html.markdown", "w") {|f| f.print("Markdown contents") }
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
    FileUtils.remove_entry_secure(normal_repo)
    FileUtils.remove_entry_secure(bare_repo)
  end
end
