require 'redis'
require 'liquid'
require 'mime/types'
require 'pathname'
require 'active_support/core_ext'

require_relative "blimp/source"
require_relative "blimp/sources/disk_source"
require_relative "blimp/sources/mock_source"

require_relative "blimp/source_dir"
require_relative "blimp/source_file"

require_relative "blimp/site"
require_relative "blimp/theme"
require_relative "blimp/page"

require_relative "blimp/web_server"

module Blimp
  def self.root
    Pathname.new(File.dirname(__FILE__)).join("..")
  end
end
