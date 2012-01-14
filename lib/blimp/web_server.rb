require 'sinatra/base'

module Blimp
  class WebServer < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    before do
      logger.info "Sites defined: #{Site.all}"
      @site = Site.find_by_domain(request.host) or raise Sinatra::NotFound, "No site defined for #{request.host}"
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
