module Blimp
  module Handlers
    class StaticHandler < Blimp::Handler
      NAME = "static"

      def handle(source, theme, path, params = {})
        resource = Static.from_path(path, source)
        headers  = {"Content-Type" => resource.mimetype}
        body     = resource.contents
        
        [headers, body]
      end
    end
  end
end
