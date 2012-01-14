require 'yaml'

class Site
  attr_reader :key
  attr_reader :source
  attr_reader :theme

  liquid_methods :title

  def initialize(key, source)
    @key = key
    @source = source

    @theme = Theme.new(source, "/templates")
  end

  def find_page(path)
    Page.from_path(path, source)
  end

  def render_page(page)
    theme.render_page(page)
  end

end
