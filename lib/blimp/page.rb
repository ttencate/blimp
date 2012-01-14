class Page
  class NotFound < StandardError; end

  attr_reader :body
  attr_reader :mimetype

  def self.from_path(path, source)
    source_file = begin
                    source.get_file(path)
                  rescue SourceFile::NotFound
                    source.get_file(source.get_filenames_by_prefix(path).first)
                  end
    source_mimetype = MIME::Types.type_for(source_file.path).first.to_s
    contents, mimetype = Blimp::Renderer.render(source_file.contents, source_mimetype)
    self.new(contents, mimetype)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(body, mimetype)
    @body = body
    @mimetype = mimetype
  end
end
