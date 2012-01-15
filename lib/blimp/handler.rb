require 'sinatra/base'

module Blimp
  class Handler < Sinatra::Base
    def name
      return @NAME
    end

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

    # TODO taking source and theme here is ugly
    def initialize(path, source, theme)
      @path = path
      @source = source
      @theme = theme
    end

    protected

    attr_reader :path
    attr_reader :source
    attr_reader :theme
  end
end
