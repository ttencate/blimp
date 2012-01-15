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

RSpec::Matchers.define :have_types do |types|
  match do |array|
    array.length == types.length and array.zip(types).map {|element, type| element.is_a?(type) }.all?
  end
  failure_message_for_should do |array|
    "Expected types #{types}, got types #{array.map {|e| e.class}}"
  end
end

RSpec.configure do |config|
  config.before(:each) { Sites.clear }
end
