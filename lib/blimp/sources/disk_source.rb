module Blimp
  module Sources
    class DiskSource < Blimp::Source
      attr_reader :root

      def initialize(root)
        @root = root
      end

      def get_file(path)
        raise SourceFile::NotFound, path if hidden?(path)
        contents = File.read(disk_path(path))
        SourceFile.new(path, contents)
      rescue
        raise SourceFile::NotFound, path
      end

      def get_dir(path)
        raise SourceDir::NotFound, path if hidden?(path)
        entries = []
        Dir.entries(disk_path(path)).each do |entry|
          entry_path = File.join(path, entry)
          next if hidden?(entry_path)
          entries << entry_path
        end
        entries.sort!
        SourceDir.new(path, entries)
      rescue
        raise SourceDir::NotFound, path
      end

      def is_file?(path)
        visible?(path) and File.file?(disk_path(path))
      end

      def is_dir?(path)
        visible?(path) and File.directory?(disk_path(path))
      end

      protected

      def disk_path(path)
        File.join(root, path)
      end
    end
  end
end
