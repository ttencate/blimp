require 'yaml'

class Site
  attr_reader :key
  attr_reader :redis

  liquid_methods :title

  def initialize(key, source, redis)
    @key = key
    @redis = redis
  end

  def layout(name = "layout")
    layout_content = File.read(File.join(templates_path, "#{name}.liquid"))
    Liquid::Template.parse(layout_content)
  end

  def find_page(path)
    Page.from_path(path, redis, self)
  end

  protected

  def templates_path
    File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "templates"))
  end

end
