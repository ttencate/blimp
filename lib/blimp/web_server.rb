require 'sinatra/base'

module Blimp
  class WebServer < Sinatra::Base
    before do
      @root = File.join(File.expand_path(File.dirname(__FILE__)), "../../sample")
      @redis = Redis.new
      @source = Blimp::Sources::DiskSource.new(@root)
      @site = Site.new(@root, @source, @redis)
      FileSystemSyncer.new(@root, @redis).sync!
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
