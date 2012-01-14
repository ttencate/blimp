module Blimp
  class Handler
    class NotFound < StandardError; end

    class << self
      attr_reader :name

      def find_by_name(name)
        for constant in Blimp::Handlers.constants do
          handler = Blimp::Handlers.const_get(constant)
          return handler if handler < Blimp::Handler && handler.name == name
        end
        raise NotFound, "No handler found for name #{name}"
      end
    end

    def initialize(source, path)
      @source = source
      @path = path
    end
  end
end
