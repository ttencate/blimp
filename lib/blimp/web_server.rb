require 'sinatra/base'

module Blimp
  class WebServer < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    before do
      logger.info "Started GET \"#{request.path_info}\" for #{request.ip} at #{Time.now.strftime("%Y-%m-%d %H:%M:%s")}"
      @site = Sites.find_by_domain(request.host) or raise Sinatra::NotFound, "No site defined for #{request.host}"
    end

    after do
      logger.info ""
    end

    get '*' do
      begin
        handler = @site.handler_for_path(request.path_info)
        response_headers, response_body = handler.handle(request.path_info, params)
      rescue Site::NoHandler
        raise Sinatra::NotFound
      end

      headers response_headers
      body    response_body
    end
  end
end
