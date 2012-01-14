class Page
  class NotFound < StandardError; end

  attr_reader :body
  attr_reader :mimetype

  def self.from_path(path, source)
    source_file = source.get_file(path)
    source_mimetype = MIME::Types.type_for(path).first.to_s
    contents, mimetype = Blimp::Renderer.render(source_file.contents, source_mimetype)
    self.new(contents, mimetype)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(body, mimetype)
    @body = body
    @mimetype = mimetype
  end

  def headers
    {"Content-Type" => mimetype}
  end
end
