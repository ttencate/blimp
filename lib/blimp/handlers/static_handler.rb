module Blimp
  module Handlers
    class StaticHandler < Blimp::Handler
      NAME = "static"

      def handle(source, theme, path, params = {})
        begin
          resource = Static.from_path(path, source)
        rescue Static::NotFound
          raise SourceNotFound
        end
        headers  = {"Content-Type" => resource.mimetype}
        body     = resource.contents
        
        [headers, body]
      end
    end
  end
end
