module Blimp
  class Source

    def get_filenames_by_prefix(path)
      dir = get_dir(File.dirname(path))
      dir.entries.select {|entry| entry.starts_with?(path) }
    end

    protected

    def visible?(path)
      not hidden?(path)
    end

    def hidden?(path)
      path.split("/").any? {|component| component.start_with?(".") }
    end

  end
end
