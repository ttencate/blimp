require 'yaml'

class Site
  attr_reader :key
  attr_reader :source
  attr_reader :theme
  attr_reader :domains

  liquid_methods :title

  class << self
    protected
    attr_accessor :sites

    public
    def add(site)
      self.sites ||= []
      self.sites << site
    end

    def all
      self.sites
    end
    
    def find_by_domain(domain)
      Site.all.find {|i| i.has_domain?(domain) }
    end
  end

  def initialize(key, source, options = {})
    @key = key
    @source = source
    @domains = options[:domains] || []

    @theme = Theme.new(source, "/templates")
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

end
