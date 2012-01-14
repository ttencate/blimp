require 'sinatra/base'

module Blimp
  class WebServer < Sinatra::Base
    before do
      @root = File.join(Blimp.root.join("sample"))
      @source = Blimp::Sources::DiskSource.new(@root)
      @site = Site.new(@root, @source)
    end
    
    get '*' do
      begin
        page = @site.find_page(request.path_info)
      rescue Page::NotFound
        raise Sinatra::NotFound
      end

      headers page.headers
      body    page.body 
    end
  end
end
