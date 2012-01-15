class Router
  def initialize(handler_config = [])
    @handlers = { "/" => [
      Blimp::Handlers::PageHandler.new("/"),
      Blimp::Handlers::StaticHandler.new("/"),
    ] }
    for handler_config in handler_config || [] do
      path = handler_config[:path]
      names = handler_config[:handler]
      names = [names] if not names.is_a?(Array)
      handlers[path] = names.map {|name| Blimp::Handler.find_by_name(name).new(path) }
    end
  end

  def handlers_for_path(path)
    raise ArgumentError, "Path #{path} does not start with a slash" if not path.start_with?("/")
    handler_list = []
    while not path == "/"
      handler_list += handlers[path] || []
      path = File.dirname(path)
    end
    handler_list += handlers[path] # now /
    return handler_list
  end

  protected

  attr_reader :handlers
end
