require 'rb-inotify'

module Blimp
  module Sources
    class GitWatcher
      def initialize
        @notifier = INotify::Notifier.new
        @watchers = {}
      end

      def watch(git_source, &block)
        raise ArgumentError, "block must not be nil" if block.nil?
        ws = []
        begin
          ws << notifier.watch(git_source.head_path, :close_write) {|event|
            print "Calling block"
            block.call
          }
          print "#{self} is watching #{git_source.head_path}"
        rescue Errno::ENOENT
        end
        begin
          ws << notifier.watch(File.join(git_source.path, "packed-refs"), :close_write) {|event|
            print "Calling block"
            block.call
          }
          print "#{self} is watching #{git_source.path}/packed-refs"
        rescue Errno::ENOENT
        end
        raise RuntimeError, "Neither a packed nor an unpacked ref was found" if ws.empty?
        watchers[git_source] = ws
      end

      def unwatch(git_source)
        watchers[git_source].each {|w| w.close }
      end

      def process
        notifier.process
      end

      protected

      attr_reader :notifier
      attr_reader :watchers
    end
  end
end
