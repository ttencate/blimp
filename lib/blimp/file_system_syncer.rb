class FileSystemSyncer
  attr_reader :root
  attr_reader :redis

  def initialize(root, redis)
    raise ArgumentError, "root dir must exist" unless File.directory?(root)
    @root = root
    @redis = redis
  end

  def sync!
    sync_entry!("/")
  end

  protected

  # TODO Race conditions might occur when user modifies
  # filesystem while syncing
  def sync_entry!(path)
    if File.directory?(File.join(root, path))
      sync_dir!(path)
    else
      sync_file!(path)
    end
  end

  def sync_dir!(path)
    source_dir = SourceDir.new(path)

    Dir.entries(File.join(root, path)).each do |entry|
      next if entry == "." or entry == ".."
      source_dir.entries << sync_entry!(File.join(path, entry)).key
    end

    source_dir.save_to(redis)
    source_dir
  end

  def sync_file!(path)
    contents = File.read(File.join(root, path))
    source_file = SourceFile.new(path, contents)
    source_file.save_to(redis)
    source_file
  end

end
