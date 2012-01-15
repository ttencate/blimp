require "yaml"

class Site
  class InvalidConfig < StandardError; end
  class NoHandler < StandardError; end
  CONFIG_FILE_PATH = "/_blimp.yaml"

  attr_reader :key
  attr_reader :source
  attr_reader :theme
  attr_reader :domains

  liquid_methods :title

  def initialize(key, source, options = {})
    @key = key
    @source = source
    @domains = options[:domains] || []

    @theme = Theme.new(source, "/templates")

    config = load_config
    @router = Router.new(config["handlers"])
  end

  def handler_for_path(path)
    router.handler_for_path(path)
  end

  def find_page(path)
    Page.from_path(path, source)
  end

  def render_page(page)
    theme.render_page(page)
  end

  def has_domain?(domain)
    domains.include?(domain)
  end

  protected

  attr_reader :router

  private

  def load_config
    begin
      config_file = source.get_file(CONFIG_FILE_PATH).contents
      config = YAML::load(config_file) || {}
    rescue SourceFile::NotFound
      config = {}
    rescue Psych::SyntaxError => e
      raise InvalidConfig, e.message
    end
    raise InvalidConfig, "Config must be a hash" unless config.is_a?(Hash)
    return config.with_indifferent_access
  end

end
