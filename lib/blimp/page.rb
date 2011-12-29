class Page
  class NotFound < StandardError; end

  attr_reader :path, :body

  def self.from_path(path, redis)
    source_file = SourceFile.load_from(redis, path)
    self.new(path, source_file.contents)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(path, body)
    @path = path
    @body = body
  end

  def headers
    case File.extname(path)
    when ".jpg"
      {"Content-Type" => "image/jpeg"}
    else
       {"Content-Type" => "text/html"}
    end
  end
  
end
