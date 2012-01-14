require "yaml"

class Site
  class InvalidConfig < StandardError; end
  class NoHandler < StandardError; end
  CONFIG_FILE_PATH = "/_blimp.yaml"

  attr_reader :key
  attr_reader :source
  attr_reader :theme
  attr_reader :domains
  attr_reader :handlers

  liquid_methods :title

  def initialize(key, source, options = {})
    @key = key
    @source = source
    @domains = options[:domains] || []

    @theme = Theme.new(source, "/templates")

    config = load_config

    @handlers = { "/" => [
      Blimp::Handlers::PageHandler.new(source, "/"),
      Blimp::Handlers::StaticHandler.new(source, "/"),
    ] }
    for handler_config in config[:handlers] || [] do
      path = handler_config[:path]
      names = handler_config[:handler]
      names = [names] if not names.is_a?(Array)
      handlers[path] = names.map {|name| Blimp::Handler.find_by_name(name).new(source, path) }
    end
  end

  def handlers_for_path(path)
    raise ArgumentError, "Path #{path} does not start with a slash" if not path.start_with?("/")
    handler_list = []
    while not path == "/"
      handler_list += handlers[path] || []
      path = File.dirname(path)
    end
    handler_list += handlers[path] # now /
    return handler_list
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
