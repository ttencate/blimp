class Page
  class NotFound < StandardError; end

  attr_reader :path
  attr_reader :site

  def self.from_path(path, redis, site)
    source_file = SourceFile.load_from(redis, path)
    self.new(path, source_file.contents, site)
  rescue SourceFile::NotFound
    raise NotFound
  end

  def initialize(path, body, site)
    @path = path
    @body = body
    @site = site
  end

  def headers
    {"Content-Type" => MIME::Types.type_for(path).first.to_s} 
  end

  def body
    if render_layout?
      site.layout.render("content" => @body)
    else
      @body
    end
  end

  protected

  def render_layout?
    case File.extname(path)
    when ".html", ".mdown"
      true
    else
      false
    end
  end
  
end
