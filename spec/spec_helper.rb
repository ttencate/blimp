$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV["RACK_ENV"] = "test"

# Start code coverage as the first thing
require "simplecov"
SimpleCov.start

require 'rspec'
require 'mock_redis'
require 'fakefs/spec_helpers'
require 'blimp'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:each) { Sites.clear }
end
