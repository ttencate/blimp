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
    value = redis.get(key)
    raise NotFound unless value
    self.new(path, value.split("\0"))
  end

  def save_to(redis)
    redis.set(key, entries.join("\0"))
  end

  def ==(other)
    path == other.path and
    entries == other.entries
  end
end
