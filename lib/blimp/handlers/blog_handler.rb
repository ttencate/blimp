module Blimp
  module Handlers
    class BlogHandler < Blimp::Handler
      NAME = "blog"

      get "/*/:year/:month/:day/:slug.:format" do
        blog = Blimp::Blog.from_path("/" + params[:splat].join('/'), source)
        entry = blog.entry(params[:slug])

        headers "Content-Type" => "text/html;charset=utf-8"
        # TODO verify that the theme actually returns utf-8
        body theme.render(entry.body)
      end
    end
  end
end

