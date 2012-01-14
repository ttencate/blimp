module Blimp
  class Source

    protected

    def visible?(path)
      not hidden?(path)
    end

    def hidden?(path)
      path.split("/").any? {|component| component.start_with?(".") }
    end

  end
end
