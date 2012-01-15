module Blimp
  class Handler
    class NotFound < StandardError; end

    class << self
      def find_by_name(name)
        for constant in Blimp::Handlers.constants do
          handler = Blimp::Handlers.const_get(constant)
          return handler if handler < Blimp::Handler && handler::NAME == name
        end
        raise NotFound, "No handler found for name #{name}"
      end
    end

    def initialize(path)
      @path = path
    end
  end
end
