class SourceDir
  class NotFound < StandardError; end

  attr_reader :path
  attr_accessor :entries

  def initialize(path, entries = [])
    raise ArgumentError, "path must be absolute" unless path =~ /^\//
    @path = path
    @entries = entries
  end

  def ==(other)
    path == other.path and entries == other.entries
  end
end
