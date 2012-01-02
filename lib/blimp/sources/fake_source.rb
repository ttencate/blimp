module Blimp
  module Sources
    class FakeSource < Blimp::Source
      def initialize(tree)
        @files = {}
        @dirs = {}
        store_tree("/", tree)
      end

      def get_file(path)
        raise SourceFile::NotFound if not files.has_key?(path)
        SourceFile.new(path, files[path])
      end

      def get_dir(path)
        raise SourceDir::NotFound if not dirs.has_key?(path)
        SourceDir.new(path, dirs[path])
      end

      def is_file?(path)
        files.has_key?(path)
      end

      def is_dir?(path)
        dirs.has_key?(path)
      end

      protected

      attr_reader :files
      attr_reader :dirs

      def store_tree(path, tree)
        if tree.is_a?(Hash) then
          entries = []
          tree.each do |key, value|
            entry_path = File.join(path, key)
            entries << entry_path
            store_tree(entry_path, value)
          end
          dirs[path] = entries.sort
        else
          files[path] = tree
        end
      end
    end
  end
end
