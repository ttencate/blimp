require 'redis'
require 'liquid'
require 'kramdown'
require 'mime/types'
require 'pathname'
require 'active_support/core_ext'

require_relative "blimp/source"
require_relative "blimp/sources/disk_source"
require_relative "blimp/sources/fake_source"
require_relative "blimp/sources/git_source"
require_relative "blimp/sources/git_watcher"
require_relative "blimp/sources/redis_source"

require_relative "blimp/source_dir"
require_relative "blimp/source_file"

require_relative "blimp/handler"
require_relative "blimp/handlers/blog_handler"
require_relative "blimp/handlers/page_handler"
require_relative "blimp/handlers/static_handler"

require_relative "blimp/site"
require_relative "blimp/sites"
require_relative "blimp/theme"
require_relative "blimp/page"
require_relative "blimp/static"
require_relative "blimp/renderer"
require_relative "blimp/router"

require_relative "blimp/blog"
require_relative "blimp/post"

require_relative "blimp/web_server"

markdown = MIME::Type.from_hash('Content-Type' => 'text/markdown',
                                'Extensions' => ['markdown', 'mdown', 'md'])
MIME::Types.add(markdown)

module Blimp
  def self.gem_root
    Pathname.new(File.dirname(__FILE__)).join("..")
  end
end
