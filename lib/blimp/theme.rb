class Theme
  attr_reader :source, :root

  def initialize(source, root)
    @source = source
    @root   = root
  end

  def layout
    template = @source.get_file(File.join(root, "layout.liquid")).contents
    Liquid::Template.parse(template)
  end

  def render_page(page)
    layout.render('content' => page.body)
  end

end
