class SourceDir
  class NotFound < StandardError; end

  attr_reader :path
  attr_accessor :entries

  def initialize(path, entries = [])
    raise ArgumentError, "path must be absolute" unless path =~ /^\//
    @path = path
    @entries = entries
  end

  def key
    self.class.key(path)
  end

  def self.key(path)
    "d:" + path
  end

  def self.load_from(redis, path)
    key = key(path)
    entries = redis.smembers(key)
    entries = entries.sort()
    self.new(path, entries)
  end

  def save_to(redis)
    redis.del(key)
    for entry in entries do
      redis.sadd(key, entry)
    end
  end

  def ==(other)
    path == other.path and
    entries == other.entries
  end
end
