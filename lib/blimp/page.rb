class Page
  class NotFound < StandardError; end

  attr_reader :body

  def self.from_path(path, redis)
    source_file = SourceFile.load_from(redis, path)
    self.new(source_file.contents)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(body)
    @body = body
  end

  def headers
    {"Content-Type" => "text/html"}
  end
  
end
