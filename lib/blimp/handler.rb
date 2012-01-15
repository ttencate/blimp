require 'sinatra/base'

module Blimp
  class Handler < Sinatra::Base
    class HandlerNotFound < StandardError; end
    class CantTouchThis < StandardError; end
    
    set :raise_errors, true

    class << self
      def find_by_name(name)
        for constant in Blimp::Handlers.constants do
          handler = Blimp::Handlers.const_get(constant)
          return handler if handler < Blimp::Handler && handler::NAME == name
        end
        raise HandlerNotFound, "No handler found for name #{name}"
      end
    end

    def initialize(path)
      @path = path
    end

    before do
      @source = env["blimp.source"]
      @theme = env["blimp.theme"]
    end

    protected

    attr_reader :path
    attr_reader :source
    attr_reader :theme
  end
end
