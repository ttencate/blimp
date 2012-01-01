require "spec_helper"

describe Blimp::Sources::DiskSource do
  describe "#initialize" do
    it "should take a root path and a redis" do
      redis = MockRedis.new
      source = Blimp::Sources::DiskSource.new("/root", redis)
      source.root.should == "/root"
      source.redis.should == redis
    end
  end
end
