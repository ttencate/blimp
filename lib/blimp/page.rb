class Page
  class NotFound < StandardError; end

  attr_reader :path
  attr_reader :body

  def self.from_path(path, source)
    source_file = source.get_file(path)
    self.new(path, source_file.contents)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(path, body)
    @path = path
    @body = body
  end

  def headers
    {"Content-Type" => MIME::Types.type_for(path).first.to_s} 
  end
  
end
