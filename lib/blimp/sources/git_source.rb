require "grit"

module Blimp
  module Sources
    class GitSource < Blimp::Source
      class NoRepo < StandardError; end

      attr_reader :root

      def initialize(root)
        @root = root
        begin
          @repo = Grit::Repo.new(root)
        rescue Grit::NoSuchPathError
          raise NoRepo, "Repo directory #{root} does not exist"
        rescue Grit::InvalidGitRepositoryError
          # Maybe it's a bare repo?
          # Grit does not check anything beyond existence of the directory, we do.
          raise NoRepo, "No git repository found in #{root}" if not File.exists?(File.join(root, "HEAD"))
          @repo = Grit::Repo.new(root, :is_bare => true)
        end
      end

      def get_file(path)
        raise SourceFile::NotFound if hidden?(path)
        blob = resolve_path(path)
        raise SourceFile::NotFound if not blob.is_a?(Grit::Blob)
        SourceFile.new(path, blob.data)
      end

      def get_dir(path)
        raise SourceDir::NotFound if hidden?(path)
        tree = resolve_path(path)
        raise SourceDir::NotFound if not tree.is_a?(Grit::Tree)
        entries = []
        entries += tree.trees.map {|tree| File.join(path, tree.name) }
        entries += tree.blobs.map {|blob| File.join(path, blob.name) }
        entries.delete_if {|path| hidden?(path) }
        entries.sort!
        SourceDir.new(path, entries)
      end

      def is_file?(path)
        visible?(path) and resolve_path(path).is_a?(Grit::Blob)
      end

      def is_dir?(path)
        visible?(path) and resolve_path(path).is_a?(Grit::Tree)
      end

      protected

      attr_reader :repo

      def tree
        repo.tree
      end

      def resolve_path(path)
        dir = tree
        for component in path.split("/") do
          next if component.empty?
          dir = dir/component
          return nil if dir.nil?
        end
        dir
      end
    end
  end
end

