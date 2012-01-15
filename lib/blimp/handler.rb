module Blimp
  class Handler
    class HandlerNotFound < StandardError; end
    class SourceNotFound < StandardError; end

    def name
      return @NAME
    end

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
  end
end
