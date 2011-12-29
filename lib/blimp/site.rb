class Site
  liquid_methods :title

  attr_reader :root

  class Config
    def self.load(path)
      YAML.load(path)
    end
  end

  def initialize(root)
    @root = root
  end
  
  def config
    Config.load(File.join(root, ".config.yml"))
  end

  def templates_path
    File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "templates"))
  end

  def layout(name = "layout")
    layout_content = File.read(File.join(templates_path, "#{name}.liquid"))
    Liquid::Template.parse(layout_content)
  end
end
