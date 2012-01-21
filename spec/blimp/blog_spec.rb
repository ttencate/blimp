require 'spec_helper'

describe Blimp::Blog do
  let(:blog) { Blimp::Blog.new("/blog", source) }
  let(:source) do
    Blimp::Sources::FakeSource.new({
      "blog" => {"2012-01-01-first-post.html.markdown" => "First"}
    })
  end

  context "for an empty blog" do
    let(:blog) { Blimp::Blog.new("/blog", source) }
    let(:source) { Blimp::Sources::FakeSource.new({"blog" => {}}) }

    it 'has no entries' do
      blog.entries.should == []
    end
  end

  context "for a blog with one post" do
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

  describe '#entry' do
    let(:slug) { "first-post" }
    let(:post) { stub(:slug => slug) }

    it 'returns the entry' do
      blog.stub(:entries => [post])
      blog.entry(slug).should == post
    end

    it 'raises EntryNotFound if no entry exists' do
      blog.stub(:entries => [])
      expect { blog.entry(slug) }.to raise_error(Blimp::Blog::EntryNotFound)
    end
  end
end
