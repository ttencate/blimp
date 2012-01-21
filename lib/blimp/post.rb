require 'date'

module Blimp
  class Post
    attr_accessor :date
    attr_accessor :body

    def self.parse(filename, string)
      new.tap do |post|
        post.date = parse_date(filename)
        post.body = string
      end
    end

    def self.parse_date(filename)
      Date.parse(filename)
    end
  end
end
