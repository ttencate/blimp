require 'date'

module Blimp
  class Post
    attr_accessor :date
    attr_accessor :body
    attr_accessor :slug

    def self.parse(filename, string)
      new.tap do |post|
        post.date = parse_date(filename)
        post.slug = parse_slug(filename)
        post.body = string
      end
    end

    protected

    def self.parse_date(filename)
      Date.parse(filename)
    end

    def self.parse_slug(filename)
      filename.match(/\d{4}-\d{2}-\d{2}-(.*)\..*/)[1]
    end
  end
end
