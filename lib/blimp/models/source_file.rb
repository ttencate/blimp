class SourceFile
  class NotFound < StandardError; end

  attr_reader :path
  attr_accessor :contents
  
  def initialize(path, contents = "")
    raise ArgumentError, "path must be absolute" unless path =~ /^\//
    @path = path
    @contents = contents
  end

  def key
    self.class.key(path)
  end

  def self.key(path)
    "f:" + path
  end

  def self.load_from(redis, path)
    key = key(path)
    contents = redis.get(key)
    raise NotFound unless contents
    self.new(path, contents)
  end

  def save_to(redis)
    redis.set(key, contents)
  end

  def ==(other)
    path == other.path and contents == other.contents
  end

end
