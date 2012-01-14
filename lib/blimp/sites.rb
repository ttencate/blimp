require "yaml"

class Sites
  class << self
    public
    def add(site)
      self.sites ||= []
      self.sites << site
    end

    def all
      self.sites || []
    end
    
    def find_by_domain(domain)
      Sites.all.find {|i| i.has_domain?(domain) }
    end

    def clear
      self.sites = []
    end

    protected
    attr_accessor :sites
  end
end
