module Blimp
  module Sources
    class RedisSource < Blimp::Source
      def initialize(redis, root)
        raise ArgumentError unless root.start_with?("/")
        @redis = redis
        @root = root
      end

      def get_file(path)
        raise ArgumentError unless path.start_with?("/")
        contents = redis.get(file_key(path)) or raise SourceFile::NotFound, path
        SourceFile.new(path, contents)
      end

      def get_dir(path)
        raise ArgumentError unless path.start_with?("/")
        keys = redis.smembers(dir_key(path))
        raise SourceDir::NotFound, path if keys.empty?
        # Redis treats empty and nonexistent sets the same way.
        # We add the empty string to each set to work around this.
        keys.delete_if {|key| key.empty?}
        entries = keys.map {|key| path_from_key(key) }
        entries.sort!
        SourceDir.new(path, entries)
      end

      def is_file?(path)
        redis.type(file_key(path)) == "string"
      end

      def is_dir?(path)
        redis.type(dir_key(path)) == "set"
      end

      protected

      attr_reader :redis
      attr_reader :root

      def file_key(path)
        "f:" + File.join(root, path).chomp("/")
      end

      def dir_key(path)
        "d:" + File.join(root, path).chomp("/")
      end

      def path_from_key(key)
        raise ArgumentError unless key.start_with?("d:") || key.start_with?("f:")
        key = key[2..-1]
        raise ArgumentError unless key.start_with?(root)
        key[root.length..-1]
      end
    end
  end
end
