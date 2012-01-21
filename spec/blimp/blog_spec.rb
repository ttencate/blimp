require 'spec_helper'

describe Blimp::Blog do
  context "for an empty blog" do
    let(:blog) { Blimp::Blog.new("/blog", source) }
    let(:source) { Blimp::Sources::FakeSource.new({"blog" => {}}) }

    it 'has no entries' do
      blog.entries.should == []
    end
  end

  context "for a blog with one post" do
    let(:blog) { Blimp::Blog.new("/blog", source) }
    let(:source) do
      Blimp::Sources::FakeSource.new({
        "blog" => {"2012-01-01-first-post.html.markdown" => "First"}
      })
    end

    it 'has one entry' do
      blog.entries.should have(1).entry
    end

    it 'has a Post' do
      blog.entries.first.should be_a(Blimp::Post)
    end

    it 'parses posts' do
      Blimp::Post.should_receive(:parse).with("/blog/2012-01-01-first-post.html.markdown", "First").once
      blog
    end
  end
end
