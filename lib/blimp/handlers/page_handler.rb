module Blimp
  module Handlers
    class PageHandler < Blimp::Handler
      NAME = "page"

      get "*" do |path|
        begin
          resource = Page.from_path(path, source)
        rescue Blimp::Renderer::UnknownType
          raise CantTouchThis
        rescue Page::NotFound
          raise Sinatra::NotFound
        end
        headers = {"Content-Type" => "text/html;charset=utf-8"}
        # TODO verify that the theme actually returns utf-8
        body    = theme.render(resource.body)
        [200, headers, body]
      end
    end
  end
end
