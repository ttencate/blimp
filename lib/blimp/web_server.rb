require 'sinatra/base'

module Blimp
  class WebServer < Sinatra::Base
    before do
      @root = File.join(File.expand_path(File.dirname(__FILE__)), "../../sample")
      @redis = Redis.new
      @site = Site.new(@root)
      FileSystemSyncer.new(@root, @redis).sync!
    end
    
    get '*' do
      begin
        page = Page.from_path(request.path_info, @redis, @site)
      rescue Page::NotFound
        raise Sinatra::NotFound
      end

      headers page.headers
      body    page.body 
    end
  end
end
