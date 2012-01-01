class SourceFile
  class NotFound < StandardError; end

  attr_reader :path
  attr_accessor :contents
  
  def initialize(path, contents = "")
    raise ArgumentError, "path must be absolute" unless path =~ /^\//
    @path = path
    @contents = contents
  end

  def ==(other)
    path == other.path and contents == other.contents
  end
end
