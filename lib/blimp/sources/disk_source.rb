module Blimp
  module Sources
    class DiskSource < Blimp::Source
      attr_reader :root

      def initialize(root)
        @root = root
      end

      def get_file(path)
        contents = File.read(disk_path(path))
        SourceFile.new(path, contents)
      rescue
        raise SourceFile::NotFound
      end

      def get_dir(path)
        entries = []
        Dir.entries(disk_path(path)).each do |entry|
          next if entry == "." or entry == ".."
          entries << File.join(path, entry)
        end
        entries.sort!
        SourceDir.new(path, entries)
      rescue
        raise SourceDir::NotFound
      end

      def is_file?(path)
        File.file?(disk_path(path))
      end

      def is_dir?(path)
        File.directory?(disk_path(path))
      end

      protected

      def disk_path(path)
        File.join(root, path)
      end
    end
  end
end
