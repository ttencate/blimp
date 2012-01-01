module Blimp
  module Sources
    class DiskSource < Blimp::Source
      attr_reader :root, :redis

      def initialize(root, redis)
        @root = root
        @redis = redis
      end
    end
  end
end
