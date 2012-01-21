require 'spec_helper'

describe Blimp::Sources::RedisSource do
  describe "#initialize" do
    it "should take a Redis instance and a root path" do
      Blimp::Sources::RedisSource.new(MockRedis.new, "/")
    end

    it "should raise if the root does not start with a slash" do
      expect {
        Blimp::Sources::RedisSource.new(MockRedis.new, "")
      }.to raise_error(ArgumentError)
    end
  end

  it_behaves_like "a source" do
    let(:redis) { MockRedis.new }
    let(:source) { Blimp::Sources::RedisSource.new(redis, "/root") }

    before do
      redis.sadd("d:/root", "")
      redis.sadd("d:/root", "d:/root/subdir")
      redis.sadd("d:/root", "d:/root/empty")
      redis.sadd("d:/root/empty", "")
      redis.sadd("d:/root", "f:/root/empty.html")
      redis.set("f:/root/empty.html", "")
      redis.sadd("d:/root/subdir", "")
      redis.sadd("d:/root/subdir", "f:/root/subdir/file.html")
      redis.sadd("d:/root/subdir", "f:/root/subdir/bounce.html.markdown")
      redis.set("f:/root/subdir/file.html", "File contents")
      redis.set("f:/root/subdir/bounce.html.markdown", "Markdown contents")
    end

    after do
      redis.flushdb
    end
  end

end
