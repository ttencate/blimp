module Blimp
  class Blog
    class EntryNotFound < StandardError; end

    attr_reader :entries

    def self.from_path(path, source)
      new(path, source)
    end

    def initialize(path, source)
      @path = path
      @source = source
      @entries = []
      @source.get_dir(path).entries.each do |file|
        @entries << Post.parse(file, source.get_file(file).contents)
      end
    end

    def entry(slug)
      entries.find { |i| i.slug == slug } or raise EntryNotFound, slug
    end
  end
end
