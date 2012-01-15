module Blimp
  module Handlers
    class PageHandler < Blimp::Handler
      NAME = "page"

      def handle(source, theme, path, params = {})
        begin
          resource = Page.from_path(path, source)
        rescue Page::NotFound
          raise SourceNotFound
        end
        headers  = {"Content-Type" => "text/html"}
        body     = theme.render(resource.body)
        
        [headers, body]
      end
    end
  end
end
