module Blimp
  class Renderer
    class UnknownType < StandardError; end
    def self.render(contents, mimetype)
      case mimetype
      when "text/html"
        [contents, mimetype]
      when "text/markdown"
        [Kramdown::Document.new(contents).to_html, "text/html"]
      else
        raise UnknownType, "Renderer does not know how to handle MIME type #{mimetype}"
      end
    end
  end
end
