module Blimp
  class Renderer
    def self.render(contents, mimetype)
      case mimetype
      when "text/html"
        [contents, mimetype]
      when "text/markdown"
        [Kramdown::Document.new(contents).to_html, "text/html"]
      else
        [contents, mimetype]
      end
    end
  end
end
