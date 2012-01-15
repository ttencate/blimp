module Blimp
  module Handlers
    class StaticHandler < Blimp::Handler
      NAME = "static"

      get "*" do |path|
        begin
          resource = Static.from_path(path, source)
        rescue Static::NotFound
          raise Sinatra::NotFound
        end
        headers = {"Content-Type" => resource.mimetype}
        body    = resource.contents
        [200, headers, body]
      end
    end
  end
end
