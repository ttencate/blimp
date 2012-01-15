module Blimp
  class WebServer

    def call(env)
      host = env["HTTP_HOST"]
      site = Sites.find_by_domain(host)
      return [404, {"Content-Type" => "text/plain"}, ["No site defined for #{host}"]] unless site
      site.call(env)
    end

  end
end
