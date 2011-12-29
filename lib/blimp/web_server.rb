require 'sinatra/base'

module Blimp
  class WebServer < Sinatra::Base
    before do
      @root = "/home/marten/prj/blimp/sample"
      @redis = Redis.new
      FileSystemSyncer.new(@root, @redis).sync!
    end
    
    get '*' do
      begin
        page = Page.from_path(request.path_info, @redis)
      rescue Page::NotFound
        raise Sinatra::NotFound
      end

      headers page.headers
      body    page.body 
    end
  end
end
