shared_examples "a source" do

  it "should list directory contents" do
    source.get_dir("/").should ==
      SourceDir.new("/", ["/empty", "/empty.html", "/subdir"])
  end

  it "should use absolute paths for directory contents" do
    source.get_dir("/subdir").should ==
      SourceDir.new("/subdir", ["/subdir/bounce.html.markdown", "/subdir/file.html"])
  end

  it "should list contents of empty directories" do
    source.get_dir("/empty").should ==
      SourceDir.new("/empty", [])
  end

  it "should load file contents" do
    source.get_file("/subdir/file.html").should ==
      SourceFile.new("/subdir/file.html", "File contents")
  end

  it "should load contents of empty files" do
    source.get_file("/empty.html").should ==
      SourceFile.new("/empty.html", "")
  end

  it "should determine that files are files" do
    source.is_file?("/empty.html").should be_true
  end

  it "should determine that directories are not files" do
    source.is_file?("/subdir").should be_false
  end

  it "should determine that nonexistent files are not files" do
    source.is_file?("/nonexistent.html").should be_false
  end

  it "should determine that directories are directories" do
    source.is_dir?("/subdir").should be_true
  end

  it "should determine that files are not directories" do
    source.is_dir?("/empty.html").should be_false
  end

  it "should determine that nonexistent directories are not directories" do
    source.is_dir?("/nonexistent").should be_false
  end

  it "should raise on directory not found" do
    expect {
      source.get_dir("/nonexistent")
    }.to raise_error(SourceDir::NotFound)
  end

  it "should raise on file not found" do
    expect {
      source.get_file("/nonexistent.html")
    }.to raise_error(SourceFile::NotFound)
  end

  describe "#get_filenames_by_prefix" do
    it "finds files based on prefix" do
      source.get_filenames_by_prefix("/subdir/bounce.html").should == ["/subdir/bounce.html.markdown"]
    end
  end
end
