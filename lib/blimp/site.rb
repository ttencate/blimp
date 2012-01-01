require 'yaml'

class Site
  attr_reader :key
  attr_reader :source
  attr_reader :theme

  liquid_methods :title

  def initialize(key, source)
    @key = key
    @source = source

    theme_source = Blimp::Sources::DiskSource.new(templates_path)
    @theme = Theme.new(theme_source, "/")
  end

  def find_page(path)
    Page.from_path(path, source)
  end

  def render_page(page)
    theme.render_page(page)
  end

  protected

  def templates_path
    File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "templates"))
  end

end
