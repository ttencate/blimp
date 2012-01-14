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
      handlers = @site.handlers_for_path(request.path_info)
      # TODO try them one by one, raise Sinatra::NotFound if all fail
      response_headers, response_body = handlers[0].handle(request.path_info, params)

      headers response_headers
      body    response_body
    end
  end
end
