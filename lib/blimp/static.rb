class Static
  class NotFound < StandardError; end

  attr_reader :contents
  attr_reader :mimetype

  def self.from_path(path, source)
    source_file = source.get_file(path)
    contents = source_file.contents
    mimetype = MIME::Types.type_for(source_file.path).first.to_s
    self.new(contents, mimetype)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(contents, mimetype)
    @contents = contents
    @mimetype = mimetype
  end
end
